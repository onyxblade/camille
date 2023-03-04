module Camille
  module Types
    class Boolean < Camille::BasicType
      def check value
        unless value == false || value == true
          Camille::TypeError.new("Expected boolean, got #{value.inspect}.")
        end
      end

      def literal
        "boolean"
      end
    end
  end
end