module Camille
  module Types
    class Number < Camille::BasicType

      def check value
        unless value.is_a?(Integer) || value.is_a?(Float)
          Camille::TypeError.new("Expected number, got #{value.inspect}.")
        end
      end
    end
  end
end