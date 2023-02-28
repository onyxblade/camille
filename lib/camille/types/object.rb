module Camille
  module Types
    class Object < Camille::Type
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

      private
        def normalize_fields fields
          fields.map do |k, v|
            [k, Camille::Type.from_value(v)]
          end.to_h
        end
    end
  end
end