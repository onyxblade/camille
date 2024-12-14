module Camille
  module Types
    class Any < Camille::BasicType
      def check value
        Camille::Checked.new(fingerprint, value)
      end

      def literal
        "any"
      end
    end
  end
end