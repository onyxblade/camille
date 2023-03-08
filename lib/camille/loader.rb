require 'thread'
require 'monitor'

module Camille
  module Loader
    extend MonitorMixin

    def self.setup_zeitwerk_loader app
      synchronize do
        loader = Zeitwerk::Loader.new
        loader.enable_reloading if !app.config.cache_classes
        loader.push_dir "#{app.root}/config/camille/types", namespace: Camille::Types
        loader.push_dir "#{app.root}/config/camille/schemas", namespace: Camille::Schemas

        loader.setup
        loader.eager_load
        loader
      end
    end

    def self.reload_types_and_schemas zeitwerk_loader
      synchronize do
        Camille::Loader.loaded_types.clear
        Camille::Loader.loaded_schemas.clear
        Camille::Schemas.controller_schema_map.clear
        zeitwerk_loader.reload
        zeitwerk_loader.eager_load
      end
    end

    def self.register_routes router_context
      Camille::Loader.loaded_schemas.each do |schema|
        schema.endpoints.each do |name, endpoint|
          router_context.public_send(endpoint.verb, endpoint.path, controller: schema.path.gsub(/^\//, ''), action: endpoint.name, as: false)
        end
      end
    end

    def self.loaded_types
      synchronize do
        @loaded_types ||= []
      end
    end

    def self.loaded_schemas
      synchronize do
        @loaded_schemas ||= []
      end
    end

    def self.controller_name_to_schema_map
      synchronize do
        @controller_name_to_schema_map ||= {}
      end
    end
  end
end