module Camille
  module Types
    class Object < Camille::BasicType
      class ArgumentError < ::ArgumentError; end
      attr_reader :fields

      def initialize fields
        @optional_keys = []
        @fields = normalize_fields fields
      end

      def transform_and_check value
        if value.is_a? Hash
          keys = (@fields.keys + value.keys).uniq
          transform_and_check_results = keys.map do |key|
            if type = @fields[key]
              error, transformed = type.transform_and_check(value[key])
              if @optional_keys.include?(key) && !error && transformed.nil?
                nil
              else
                [key, [error, transformed]]
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
            [nil, transformed]
          else
            [Camille::TypeError.new(**errors.to_h), nil]
          end
        else
          [Camille::TypeError.new("Expected hash, got #{value.inspect}."), nil]
        end
      end

      def literal
        "{#{@fields.map{|k,v| "#{ActiveSupport::Inflector.camelize k.to_s, false}: #{v.literal}"}.join(', ')}}"
      end

      private
        def normalize_fields fields
          fields.map do |key, value|
            check_case_conversion_safe key
            type = Camille::Type.instance(value)
            if key.end_with?('?')
              new_key = remove_question_mark(key)
              @optional_keys << new_key
              [new_key, type | Camille::Types::Undefined.new]
            else
              [key, type]
            end
          end.to_h
        end

        def remove_question_mark sym
          sym.to_s.gsub(/\?$/, '').to_sym
        end

        def check_case_conversion_safe sym
          str = sym.to_s
          if str != str.camelize.underscore
            raise ArgumentError.new("Only keys satisfying `key.to_s == key.to_s.camelize.underscore` can be used.")
          end
        end
    end
  end
end