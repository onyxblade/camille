module Camille
  class Schema
    class AlreadyDefinedError < ::ArgumentError; end

    include Camille::Types

    def self.endpoints
      @endpoints ||= {}
    end

    def self.const_missing name
      Camille::Types.const_get(name)
    end

    def self.path
      "/#{ActiveSupport::Inflector.underscore self.name.gsub(/^Camille::Schemas::/, '')}"
    end

    def self.literal_lines
      [
        '{',
        *endpoints.map do |k, e|
          "  #{e.function},"
        end,
        '}'
      ]
    end

    def self.inherited klass
      Camille::Schemas.loaded_schemas << klass
    end

    private
      def self.define_endpoint verb, name, &block
        if endpoints[name]
          raise AlreadyDefinedError.new("Endpoint `#{name}` has already been defined.")
        end
        endpoint = Camille::Endpoint.new self, verb, name
        endpoint.instance_exec &block

        endpoints[name] = endpoint
      end

      def self.get name, &block
        define_endpoint :get, name, &block
      end

      def self.post name, &block
        define_endpoint :post, name, &block
      end
  end
end