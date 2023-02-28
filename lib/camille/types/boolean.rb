module Camille
  module Types
    class Boolean < Camille::Type
      def check value
        unless value == false || value == true
          Camille::TypeError.new("Expected boolean, got #{value.inspect}.")
        end
      end
    end
  end
end