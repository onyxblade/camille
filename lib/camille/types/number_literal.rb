module Camille
  module Types
    class NumberLiteral < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      def initialize value
        if value.is_a?(Integer) || value.is_a?(Float)
          @value = value
        else
          raise ArgumentError.new("Expecting an integer or a float, got #{value.inspect}")
        end
      end

      def check value
        unless value == @value
          Camille::TypeError.new("Expected number literal #{@value.inspect}, got #{value.inspect}.")
        end
      end

      def literal
        @value.to_s
      end
    end
  end
end