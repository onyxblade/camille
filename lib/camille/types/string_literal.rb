module Camille
  module Types
    class StringLiteral < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      def initialize value
        if value.is_a?(::String)
          @value = value
        else
          raise ArgumentError.new("Expecting a string, got #{value.inspect}")
        end
      end

      def check value
        unless value == @value
          Camille::TypeError.new("Expected string literal #{@value.inspect}, got #{value.inspect}.")
        end
      end

      def literal
        @value.inspect
      end
    end
  end
end