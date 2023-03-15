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

          types_dir = "#{app.root}/config/camille/types"
          schemas_dir = "#{app.root}/config/camille/schemas"

          if Dir.exist? types_dir
            loader.push_dir types_dir, namespace: Camille::Types
          else
            unless inside_generator?
              puts "[Camille Warning] Expected folder `config/camille/types`. Run `rails g camille:install` to fix it."
            end
          end

          if Dir.exist? schemas_dir
            loader.push_dir schemas_dir, namespace: Camille::Schemas
          else
            unless inside_generator?
              puts "[Camille Warning] Expected folder `config/camille/schemas`. Run `rails g camille:install` to fix it."
            end
          end

          loader.setup
          @zeitwerk_loader = loader
          @configuration_location = "#{app.root}/config/camille/configuration.rb"

          eager_load
          construct_controller_name_to_schema_map
        end
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

      private
        def eager_load
          if File.exist?(@configuration_location)
            load @configuration_location
          else
            unless inside_generator?
              puts "[Camille Warning] Expected file `config/camille/configuration.rb`. Run `rails g camille:install` to fix it."
            end
          end
          @zeitwerk_loader.eager_load
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

        def inside_generator?
          # https://stackoverflow.com/a/53963584
          !(Rails.const_defined?(:Server) || Rails.const_defined?(:Console))
        end

    end

  end
end