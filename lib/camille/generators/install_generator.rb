
module Camille
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc 'install camille'

      def copy_configuration_file
        copy_file "configuration.rb", "config/camille/configuration.rb"
      end

      def copy_type_example
        copy_file "type_example.rb", "config/camille/types/example.rb"
      end

      def copy_schema_example
        copy_file "schema_example.rb", "config/camille/schemas/examples.rb"
      end

    end
  end
end