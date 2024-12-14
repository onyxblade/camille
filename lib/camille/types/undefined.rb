module Camille
  module Types
    class Undefined < Camille::BasicType
      def check value
        if value == nil
          Camille::Checked.new(fingerprint, value)
        else
          Camille::TypeError.new("Expected nil, got #{value.inspect}.")
        end
      end

      def literal
        "undefined"
      end
    end
  end
end