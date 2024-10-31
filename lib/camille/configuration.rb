
module Camille
  class Configuration
    class << self
      attr_reader :response_key_converter, :params_key_converter
      attr_accessor :ts_header, :ts_location

      def load_default_configurations
        self.response_key_converter = lambda do |string|
          string.camelize(:lower)
        end

        self.params_key_converter = lambda do |string|
          string.underscore
        end
      end

      def response_key_converter= lambda
        @response_key_converter = lambda
        Camille::Type.define_method :convert_response_key, &lambda
      end

      def params_key_converter= lambda
        @params_key_converter = lambda
        Camille::Type.define_method :convert_params_key, &lambda
      end

      Camille::Configuration.load_default_configurations
    end
  end
end