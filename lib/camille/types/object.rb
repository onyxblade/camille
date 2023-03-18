module Camille
  module Types
    class Object < Camille::BasicType
      attr_reader :fields

      def initialize fields
        @fields = normalize_fields fields
      end

      def check value
        if value.is_a? Hash
          errors = @fields.map do |key, type|
            [key.to_s, type.check(value[key])]
          end.select{|x| x[1]}

          unless errors.empty?
            Camille::TypeError.new(**errors.to_h)
          end
        else
          Camille::TypeError.new("Expected hash, got #{value.inspect}.")
        end
      end

      def transform_and_check value
        if value.is_a? Hash
          transform_and_check_results = @fields.map do |key, type|
            [key, type.transform_and_check(value[key])]
          end

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
            type = Camille::Type.instance(value)
            if key.end_with?('?')
              new_key = remove_question_mark(key)
              [new_key, type | Camille::Types::Undefined.new]
            else
              [key, type]
            end
          end.to_h
        end

        def remove_question_mark sym
          sym.to_s.gsub(/\?$/, '').to_sym
        end
    end
  end
end