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
        @zeitwerk_loader = loader

        eager_load
        construct_controller_name_to_schema_map
      end
    end

    def self.eager_load
      @eager_loading = true
      @zeitwerk_loader.eager_load
      @eager_loading = false
    end

    def self.eager_loading?
      @eager_loading
    end

    def self.reload_types_and_schemas
      synchronize do
        Camille::Loader.loaded_types.clear
        Camille::Loader.loaded_schemas.clear
        @zeitwerk_loader.reload
        eager_load
        construct_controller_name_to_schema_map
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

    def self.construct_controller_name_to_schema_map
      synchronize do
        controller_name_to_schema_map.clear
        loaded_schemas.each do |schema|
          controller_class_name = "#{schema.klass_name}Controller"
          controller_name_to_schema_map[controller_class_name] = schema
        end
      end
    end

    def self.reload
      reload_types_and_schemas
      construct_controller_name_to_schema_map
      Rails.application.reload_routes!
    end

  end
end