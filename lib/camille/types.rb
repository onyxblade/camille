module Camille
  module Types
    def self.literal_lines
      Camille::TypeLiteralGenerator.new(Camille::Loader.loaded_types).literal_lines
    end
  end
end