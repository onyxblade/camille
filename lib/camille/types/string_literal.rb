module Camille
  module Types
    class StringLiteral < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :value

      def initialize value
        if value.is_a?(::String)
          @value = value
          @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@value}"
        else
          raise ArgumentError.new("Expecting a string, got #{value.inspect}")
        end
      end

      def check value
        transformed = value.is_a?(Symbol) ? value.to_s : value
        if transformed == @value
          Camille::Checked.new(fingerprint, value)
        else
          Camille::TypeError.new("Expected string literal #{@value.inspect}, got #{value.inspect}.")
        end
      end

      def literal
        @value.inspect
      end
    end
  end
end