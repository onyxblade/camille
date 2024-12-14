module Camille
  module Types
    class NumberLiteral < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :value

      def initialize value
        if value.is_a?(Integer) || value.is_a?(Float)
          @value = value
          @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@value}"
        else
          raise ArgumentError.new("Expecting an integer or a float, got #{value.inspect}")
        end
      end

      def check value
        if value == @value
          Camille::Checked.new(fingerprint, value)
        else
          Camille::TypeError.new("Expected number literal #{@value.inspect}, got #{value.inspect}.")
        end
      end

      def literal
        @value.to_s
      end
    end
  end
end