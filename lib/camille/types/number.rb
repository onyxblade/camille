module Camille
  module Types
    class Number < Camille::BasicType
      def check value
        if value.is_a?(Integer) || value.is_a?(Float)
          Camille::Checked.new(fingerprint, value)
        else
          Camille::TypeError.new("Expected an integer or a float, got #{value.inspect}.")
        end
      end

      def literal
        "number"
      end
    end
  end
end