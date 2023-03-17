
module Camille
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc 'install camille'

      def copy_configuration_file
        copy_file "configuration.rb", "config/camille/configuration.rb"
      end

      def create_types_folder
        copy_file ".keep", "config/camille/types/.keep"
      end

      def create_schemas_folder
        copy_file ".keep", "config/camille/schemas/.keep"
      end

    end
  end
end