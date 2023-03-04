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

      def literal
        "{#{@fields.map{|k,v| "#{k}: #{v.literal}"}.join(', ')}}"
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