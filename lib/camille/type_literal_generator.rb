module Camille
  class TypeLiteralGenerator
    def initialize types
      @types = types
    end

    def literal_lines
      @types.sort_by(&:klass_name).map do |type|
        instance = type.new
        Camille::Line.new("type #{instance.literal} = #{instance.underlying.literal}")
      end
    end
  end
end
