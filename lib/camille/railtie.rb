require "rails"

module Camille
  class Railtie < ::Rails::Railtie

    initializer "camille.configure_rails" do |app|
      ActionController::API.include(Camille::ControllerExtension)
      ActionController::Base.include(Camille::ControllerExtension)

      zeitwerk_loader = Camille::Loader.setup_zeitwerk_loader(app)

      app.routes.prepend do
        Camille::Loader.register_routes(self)
      end

      app.reloader.to_run do
        require_unload_lock!
        Camille::Loader.reload_types_and_schemas zeitwerk_loader
      end
    end

  end
end