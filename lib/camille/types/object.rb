module Camille
  module Types
    class Object < Camille::BasicType
      class ArgumentError < ::ArgumentError; end
      attr_reader :fields, :optional_keys

      def initialize fields
        @optional_keys = []
        @fields = normalize_fields fields
        @fingerprint = generate_fingerprint
      end

      def transform_and_check value
        if value.is_a? Hash
          keys = (@fields.keys + value.keys).uniq
          transform_and_check_results = keys.map do |key|
            if type = @fields[key]
              if @optional_keys.include?(key) && value[key].nil?
                nil
              else
                [key, type.transform_and_check(value[key])]
              end
            else
              [key, [nil, value[key]]]
            end
          end.compact

          errors = transform_and_check_results.map do |key, (error, transformed)|
            [key.to_s, error]
          end.select{|x| x[1]}

          if errors.empty?
            transformed = transform_and_check_results.map do |key, (error, transformed)|
              [key, transformed]
            end.to_h
            [nil, Camille::ObjectHash[transformed]]
          else
            [Camille::TypeError.new(**errors.to_h), nil]
          end
        else
          [Camille::TypeError.new("Expected hash, got #{value.inspect}."), nil]
        end
      end

      def check value
        if value.is_a? Hash
          keys = (@fields.keys + value.keys).uniq
          keys_to_check, keys_to_skip = keys.partition{|key| @fields[key]}

          results = keys_to_check.map do |key|
            type = @fields[key]
            if @optional_keys.include?(key) && value[key].nil?
              nil
            else
              [key, type.check(value[key])]
            end
          end.compact

          errors = results.map do |key, result|
            if result.type_error?
              [key.to_s, result]
            else
              nil
            end
          end.compact

          skipped_pairs = keys_to_skip.map do |key|
            [key, value[key]]
          end

          if errors.empty?
            Camille::Checked.new(fingerprint, results.map{|key, checked| [key, checked.value]}.concat(skipped_pairs).to_h)
          else
            Camille::TypeError.new(**errors.to_h)
          end
        else
          Camille::TypeError.new("Expected hash, got #{value.inspect}.")
        end
      end

      def literal
        "{#{@fields.map{|k,v| "#{literal_key k}: #{v.literal}"}.join(', ')}}"
      end

      private
        def normalize_fields fields
          fields.map do |key, value|
            check_key_conversion_safe key
            type = Camille::Type.instance(value)
            if key.end_with?('?')
              new_key = remove_question_mark(key)
              @optional_keys << new_key
              [new_key, type]
            else
              [key, type]
            end
          end.to_h
        end

        def remove_question_mark sym
          sym.to_s.gsub(/\?$/, '').to_sym
        end

        def literal_key key
          "#{Camille::Configuration.response_key_converter.call(key.to_s)}#{@optional_keys.include?(key) ? '?' : ''}"
        end

        def check_key_conversion_safe sym
          str = sym.to_s
          if str != Camille::Configuration.params_key_converter.call(Camille::Configuration.response_key_converter.call(str))
            raise ArgumentError.new("Only keys satisfying `key == key.to_s.camelize.underscore` can be used.")
          end
        end

        def generate_fingerprint
          sorted_fields = @fields.sort_by{|k, v| k}.map{|k, v| [k, v.fingerprint]}
          sorted_optional_keys = @optional_keys.sort
          Digest::MD5.hexdigest "#{self.class.name}#{sorted_fields}#{sorted_optional_keys}"
        end
    end
  end
end