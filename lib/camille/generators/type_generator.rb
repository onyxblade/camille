
module Camille
  module Generators
    class TypeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      desc 'generate camille type'

      def generate_type_file
        template 'type_template.erb', "config/camille/types/#{@name}.rb"
      end
    end
  end
end