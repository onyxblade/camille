require 'date'

module Camille
  module Types
    class Date < Camille::BasicType
      def check value
        unless value.is_a?(::Time) || value.is_a?(::Date)
          Camille::TypeError.new("Expected Date or Time, got #{value.inspect}.")
        end
      end

      def transform value
        value = value.to_time if value.is_a?(::Date)
        {
          '?': 'Date',
          value: value.to_i * 1000
        }
      end

      def literal
        "Date"
      end
    end
  end
end