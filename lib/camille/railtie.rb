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
        railtie.reload_types_and_schemas loader
      end
    end

    def self.reload_types_and_schemas loader
      Camille::Types.loaded_types.clear
      Camille::Schemas.loaded_schemas.clear
      loader.reload
      loader.eager_load
    end
  end
end