module Camille
  module Schemas
    def self.literal_lines
      Camille::SchemaLiteralGenerator.new(Camille::Loader.loaded_schemas).literal_lines
    end
  end
end