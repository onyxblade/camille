require 'thread'
require 'monitor'

module Camille
  module Loader
    extend MonitorMixin

    class << self
      def setup_zeitwerk_loader app
        synchronize do
          loader = Zeitwerk::Loader.new
          loader.enable_reloading if !app.config.cache_classes
          loader.push_dir "#{app.root}/config/camille/types", namespace: Camille::Types
          loader.push_dir "#{app.root}/config/camille/schemas", namespace: Camille::Schemas

          loader.setup
          @zeitwerk_loader = loader
          @configuration_location = "#{app.root}/config/camille/configuration.rb"

          eager_load
          construct_controller_name_to_schema_map
        end
      end

      def eager_load
        @eager_loading = true
        load @configuration_location
        @zeitwerk_loader.eager_load
        @eager_loading = false
      end

      def eager_loading?
        @eager_loading
      end

      def reload_types_and_schemas
        synchronize do
          Camille::Loader.loaded_types.clear
          Camille::Loader.loaded_schemas.clear
          @zeitwerk_loader.reload
          eager_load
          construct_controller_name_to_schema_map
        end
      end

      def register_routes router_context
        Camille::Loader.loaded_schemas.each do |schema|
          schema.endpoints.each do |name, endpoint|
            router_context.public_send(endpoint.verb, endpoint.path, controller: schema.path.gsub(/^\//, ''), action: endpoint.name, as: false)
          end
        end
      end

      def loaded_types
        synchronize do
          @loaded_types ||= []
        end
      end

      def loaded_schemas
        synchronize do
          @loaded_schemas ||= []
        end
      end

      def controller_name_to_schema_map
        synchronize do
          @controller_name_to_schema_map ||= {}
        end
      end

      def construct_controller_name_to_schema_map
        synchronize do
          controller_name_to_schema_map.clear
          loaded_schemas.each do |schema|
            controller_class_name = "#{schema.klass_name}Controller"
            controller_name_to_schema_map[controller_class_name] = schema
          end
        end
      end

      def reload
        synchronize do
          reload_types_and_schemas
          Rails.application.reload_routes!

          # just for spec
          @last_reload = Time.now
        end
      end

      def setup_listen app
        if !app.config.cache_classes
          require 'listen'
          listener = Listen.to("#{app.root}/config/camille") do |changed|
            #puts "Change detected. Camille reloading..."
            Camille::Loader.reload
          end
          listener.start
        end
      end

    end

  end
end