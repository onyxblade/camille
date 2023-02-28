module Camille
  module Types
    class Object < Camille::Type
      attr_reader :fields

      def initialize fields
        @fields = normalize_fields fields
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