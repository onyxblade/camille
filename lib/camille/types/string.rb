module Camille
  module Types
    class String < Camille::BasicType
      def check value
        if value.is_a?(::String) || value.is_a?(Symbol)
          Camille::Checked.new(fingerprint, value)
        else
          Camille::TypeError.new("Expected string, got #{value.inspect}.")
        end
      end

      def literal
        "string"
      end
    end
  end
end