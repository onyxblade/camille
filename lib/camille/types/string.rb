module Camille
  module Types
    class String < Camille::Type
      def check value
        unless value.is_a? ::String
          Camille::TypeError.new("Expected string, got #{value.inspect}.")
        end
      end
    end
  end
end