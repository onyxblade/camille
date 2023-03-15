
module Camille
  module Generators
    class SchemaGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      desc 'generate camille schema'

      def generate_type_file
        template 'schema_template.erb', "config/camille/schemas/#{@name}.rb"
      end
    end
  end
end