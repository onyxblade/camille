module Camille
  module Types
    class Null < Camille::BasicType
      def __check value
        unless value == nil
          Camille::TypeError.new("Expected nil, got #{value.inspect}.")
        end
      end

      def check_value value
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