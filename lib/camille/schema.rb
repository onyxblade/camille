module Camille
  class Schema
    include Camille::Types

    def self.endpoints
      @endpoints ||= {}
    end

    def self.const_missing name
      Camille::Types.const_get(name)
    end

    private
      def self.define_endpoint verb, name, &block
        endpoint = Camille::Endpoint.new verb
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