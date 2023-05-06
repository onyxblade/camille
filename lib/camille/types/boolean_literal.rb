module Camille
  module Types
    class BooleanLiteral < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :value

      def initialize value
        if value == true || value == false
          @value = value
        else
          raise ArgumentError.new("Expecting true or false, got #{value.inspect}")
        end
      end

      def check value
        unless value == @value
          Camille::TypeError.new("Expected boolean literal #{@value.inspect}, got #{value.inspect}.")
        end
      end

      def literal
        @value.to_s
      end
    end
  end
end