require "rails"

module Camille
  class Railtie < ::Rails::Railtie

    initializer "camille.configure_rails" do |app|
      ActionController::API.include(Camille::Controller)
      ActionController::Base.include(Camille::Controller)

      Camille::Loader.setup_zeitwerk_loader(app)

      app.routes.prepend do
        if Rails.env.development?
          get '/camille/endpoints.ts' => 'camille/main#endpoints_ts'
        end

        Camille::Loader.register_routes(self)
      end

      dir = "#{Rails.root}/config/camille"

      update_checker = ActiveSupport::FileUpdateChecker.new([], {dir => ['rb']}) do
        Camille::Loader.reload_types_and_schemas
      end

      app.reloaders << update_checker

      app.reloader.to_run do
        require_unload_lock!
        update_checker.execute_if_updated
      end

    end

  end
end