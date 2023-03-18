
module Camille
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc 'install camille'

      def copy_configuration_file
        copy_file "configuration.rb", "config/camille/configuration.rb"
      end

      def create_date_time_and_decimal
        copy_file "date_time.rb", "config/camille/types/date_time.rb"
        copy_file "decimal.rb", "config/camille/types/decimal.rb"
      end

      def create_schemas_folder
        copy_file ".keep", "config/camille/schemas/.keep"
      end

    end
  end
end