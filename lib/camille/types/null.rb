module Camille
  module Types
    class Null < Camille::BasicType
      def check value
        unless value == nil
          Camille::TypeError.new("Expected nil, got #{value.inspect}.")
        end
      end

      def literal
        "null"
      end
    end
  end
end