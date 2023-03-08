
module Camille
  class Configuration
    class << self
      def ts_header= string
        @ts_header = string
      end

      def ts_header
        @ts_header
      end

      def ts_location= string
        @ts_location = string
      end

      def ts_location
        @ts_location
      end
    end
  end
end