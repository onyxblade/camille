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
        Camille::Types.loaded_types.clear
        Camille::Schemas.loaded_schemas.clear
        Camille::Schemas.controller_schema_map.clear
        zeitwerk_loader.reload
        zeitwerk_loader.eager_load
      end
    end

    def self.register_routes router_context
      Camille::Schemas.loaded_schemas.each do |schema|
        schema.endpoints.each do |name, endpoint|
          router_context.public_send(endpoint.verb, endpoint.path, controller: schema.path.gsub(/^\//, ''), action: endpoint.name, as: false)
        end
      end
    end
  end
end