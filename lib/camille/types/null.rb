module Camille
  module Types
    class Null < Camille::BasicType
      def check value
        if value == nil
          Camille::Checked.new(fingerprint, value)
        else
          Camille::TypeError.new("Expected nil, got #{value.inspect}.")
        end
      end

      def literal
        "null"
      end
    end
  end
end