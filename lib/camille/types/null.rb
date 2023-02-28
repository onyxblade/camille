module Camille
  module Types
    class Null < Camille::Type
      def check value
        unless value == nil
          Camille::TypeError.new("Expected nil, got #{value.inspect}.")
        end
      end
    end
  end
end