module Camille
  module Types
    def self.literal_lines
      Camille::Loader.loaded_types.sort_by(&:klass_name).map do |type|
        instance = type.new
        Camille::Line.new("type #{instance.literal} = #{instance.underlying.literal}")
      end
    end
  end
end