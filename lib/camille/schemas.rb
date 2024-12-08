module Camille
  module Schemas
    def self.literal_lines
      [
        Camille::Line.new('{'),
        tree_literal_lines(namespace_tree).map(&:do_indent),
        Camille::Line.new('}')
      ]
    end

    private
      def self.namespace_tree
        tree = {}

        Camille::Loader.loaded_schemas.sort_by(&:klass_name).each do |s|
          path = s.klass_name.split('::')
          *namespaces, schema_name = path

          level = namespaces.inject(tree) do |level, namespace|
            level[namespace] ||= {}
            level[namespace]
          end

          level[schema_name] = s
        end

        tree
      end

      def self.tree_literal_lines tree
        tree.map do |key, value|
          if value.is_a? ::Hash
            [
              Camille::Line.new("#{Camille::Configuration.response_key_converter.call(key.to_s)}: {"),
              tree_literal_lines(value).map(&:do_indent),
              Camille::Line.new('},')
            ]
          else
            value.literal_lines.tap do |lines|
              lines.first.prepend("#{Camille::Configuration.response_key_converter.call(key.to_s)}: ")
              lines.last.append(',')
            end
          end
        end.flatten
      end
  end
end