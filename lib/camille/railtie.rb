require "rails"

module Camille
  class Railtie < ::Rails::Railtie

    railtie = self

    initializer "camille.configure_rails" do |app|
      zeitwerk_loader = Camille::Loader.setup_zeitwerk_loader(app)

      app.routes.prepend do
        Camille::Loader.register_routes(self)
      end

      app.reloader.to_run do
        require_unload_lock!
        Camille::Loader.reload_types_and_schemas zeitwerk_loader
      end

      app.reloader.to_prepare do
        railtie.install_controller_extension
      end
    end

    def self.install_controller_extension
      Camille::Loader.loaded_schemas.each do |schema|
        controller_class_name = "#{schema.klass_name}Controller"
        controller = controller_class_name.constantize

        controller.include(Camille::ControllerExtension)
        Camille::Schemas.controller_schema_map[controller] = schema
      end
    end
  end
end