require "rails"

module Camille
  class Railtie < ::Rails::Railtie
    initializer "camille.configure_rails" do |app|
      loader = Zeitwerk::Loader.new
      loader.enable_reloading if !app.config.cache_classes
      loader.push_dir "#{app.root}/config/camille/types", namespace: Camille::Types
      loader.push_dir "#{app.root}/config/camille/schemas", namespace: Camille::Schemas

      loader.setup
      loader.eager_load
    end
  end
end