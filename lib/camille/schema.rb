module Camille
  class Schema
    class AlreadyDefinedError < ::ArgumentError; end

    def self.endpoints
      @endpoints ||= {}
    end

    def self.path
      "/#{ActiveSupport::Inflector.underscore klass_name}"
    end

    def self.klass_name
      self.name.gsub(/^Camille::Schemas::/, '')
    end

    def self.literal_lines
      [
        Camille::Line.new('{'),
        *endpoints.sort_by{|k, e| k}.map do |k, e|
          Camille::Line.new("#{e.function},")
        end.map(&:do_indent),
        Camille::Line.new('}')
      ]
    end

    def self.inherited klass
      Camille::Loader.loaded_schemas << klass
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

      def self.put name, &block
        define_endpoint :put, name, &block
      end

      def self.patch name, &block
        define_endpoint :patch, name, &block
      end

      def self.delete name, &block
        define_endpoint :delete, name, &block
      end
  end
end
