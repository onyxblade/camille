module Camille
  class Type
    class InvalidTypeError < ::ArgumentError; end

    def | other
      Camille::Types::Union.new(self, other)
    end

    def []
      Camille::Types::Array.new(self)
    end

    def self.from_value value
      if value.is_a? Hash
        Camille::Types::Object.new(value)
      elsif value.is_a? Camille::Type
        value
      else
        raise InvalidTypeError.new("#{value} cannot be converted to a type.")
      end
    end
  end
end