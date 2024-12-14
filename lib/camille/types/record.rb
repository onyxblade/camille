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

      def transform_and_check value
        if value.is_a? ::Hash

          transform_and_check_results = value.map.with_index do |(k, v), index|
            [index, transform_and_check_pair(k, v)]
          end

          errors = transform_and_check_results.map do |index, (error, transformed)|
            ["record[#{index}]", error]
          end.select{|x| x[1]}

          if errors.empty?
            transformed = transform_and_check_results.map{|_, (_, transformed)| transformed}.to_h
            [nil, transformed]
          else
            [Camille::TypeError.new(**errors.to_h), nil]
          end
        else
          [Camille::TypeError.new("Expected hash, got #{value.inspect}."), nil]
        end
      end

      def self.[] key, value
        self.new key, value
      end

      def literal
        "Record<#{@key.literal}, #{@value.literal}>"
      end

      private
        def transform_and_check_pair key, value
          key_error, key_transformed = @key.transform_and_check key
          value_error, value_transformed = @value.transform_and_check value

          if key_error.nil? && value_error.nil?
            [nil, [key_transformed, value_transformed]]
          else
            errors = [['record.key', key_error], ['record.value', value_error]].select{|x| x[1]}.to_h

            error = Camille::TypeError.new(**errors)
            [error, nil]
          end
        end
    end
  end
end