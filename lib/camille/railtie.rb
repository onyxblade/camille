require "rails"

module Camille
  class Railtie < ::Rails::Railtie

    railtie = self

    initializer "camille.configure_rails" do |app|
      loader = Zeitwerk::Loader.new
      loader.enable_reloading if !app.config.cache_classes
      loader.push_dir "#{app.root}/config/camille/types", namespace: Camille::Types
      loader.push_dir "#{app.root}/config/camille/schemas", namespace: Camille::Schemas

      loader.setup
      loader.eager_load

      app.reloader.to_run do
        require_unload_lock!
        railtie.reload_types_and_schemas loader
      end

      app.reloader.to_prepare do
        railtie.install_controller_extension
      end
    end

    def self.reload_types_and_schemas loader
      Camille::Types.loaded_types.clear
      Camille::Schemas.loaded_schemas.clear
      Camille::Schemas.controller_schema_map.clear
      loader.reload
      loader.eager_load
    end

    def self.install_controller_extension
      Camille::Schemas.loaded_schemas.each do |schema|
        controller_class_name = "#{schema.klass_name}Controller"
        controller = controller_class_name.constantize

        controller.include(Camille::ControllerExtension)
        Camille::Schemas.controller_schema_map[controller] = schema
      end
    end
  end
end