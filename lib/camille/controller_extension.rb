module Camille
  module ControllerExtension
    def camille_schema
      Camille::Loader.controller_name_to_schema_map[self.class.name]
    end
  end
end