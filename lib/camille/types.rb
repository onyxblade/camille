module Camille
  module Types
    def self.loaded_types
      @loaded_types ||= []
    end

    def self.literal_lines
      @loaded_types.sort_by(&:klass_name).map do |type|
        instance = type.new
        Camille::Line.new("type #{instance.literal} = #{instance.underlying.literal}")
      end
    end
  end
end