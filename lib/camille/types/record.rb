module Camille
  module Types
    class Record < Camille::BasicType
      attr_reader :left, :right
      attr_reader :key, :value

      def initialize key, value
        @key = Camille::Type.instance key
        @value = Camille::Type.instance value
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@key.fingerprint}#{@value.fingerprint}"
      end

      def check value
        check_with_method(value, :check)
      end

      # Record keys are dynamic, so they are never converted between
      # camelCase and snake_case. Only the values are checked with
      # `check_params` so nested objects get their keys converted.
      def check_params value
        check_with_method(value, :check_params)
      end

      def self.[] key, value
        self.new key, value
      end

      def literal
        "Record<#{@key.literal}, #{@value.literal}>"
      end

      private
        def check_with_method value, method_name
          if value.is_a? ::Hash

            results = value.map.with_index do |(k, v), index|
              [index, check_pair(k, v, method_name)]
            end

            errors = results.map do |index, result|
              if result.instance_of?(Camille::TypeError)
                ["record[#{index}]", result]
              else
                nil
              end
            end.compact

            if errors.empty?
              Camille::Checked.new(fingerprint, results.map{|_, result| [result[0].value, result[1].value]}.to_h)
            else
              Camille::TypeError.new(**errors.to_h)
            end
          else
            Camille::TypeError.new("Expected hash, got #{value.inspect}.")
          end
        end

        def check_pair key, value, method_name
          key_result = @key.check key
          value_result = @value.public_send(method_name, value)

          if key_result.checked? && value_result.checked?
            [key_result, value_result]
          else
            errors = [['record.key', key_result], ['record.value', value_result]].select{|x| x[1].type_error?}.to_h

            Camille::TypeError.new(**errors)
          end
        end
    end
  end
end