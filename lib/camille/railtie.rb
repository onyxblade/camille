require "rails"

module Camille
  class Railtie < ::Rails::Railtie

    initializer "camille.configure_rails" do |app|
      ActionController::API.include(Camille::ControllerExtension)
      ActionController::Base.include(Camille::ControllerExtension)

      Camille::Loader.setup_zeitwerk_loader(app)

      app.routes.prepend do
        get '/camille/endpoints.ts' => 'camille/main#endpoints_ts'
        Camille::Loader.register_routes(self)
      end

      app.reloader.to_run do
        require_unload_lock!
        Camille::Loader.reload
      end
    end

  end
end