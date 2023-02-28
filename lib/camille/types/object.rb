module Camille
  module Types
    class Object < Camille::Type
      attr_reader :fields

      def initialize fields
        @fields = fields
      end
    end
  end
end