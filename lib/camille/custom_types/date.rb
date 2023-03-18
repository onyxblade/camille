require 'date'

# This type is only for testing, to simulate the usage of transform.
module Camille
  module CustomTypes
    class Date < Camille::Type
      include Camille::Types

      alias_of(
        type: 'Date',
        value: Number
      )

      def transform value
        case value
        when ::Date
          timestamp = value.to_time.to_i
        when ::Time
          timestamp = value.to_i
        end
        {
          type: 'Date',
          value: timestamp.to_i * 1000
        }
      end

    end
  end
end

Camille::Loader.loaded_types.delete(Camille::CustomTypes::Date)