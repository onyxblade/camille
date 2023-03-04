module Camille
  module Types
    class Undefined < Camille::BasicType
      def check value
        unless value == nil
          Camille::TypeError.new("Expected nil, got #{value.inspect}.")
        end
      end

      def literal
        "undefined"
      end
    end
  end
end