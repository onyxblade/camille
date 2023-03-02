module Camille
  class Type
    class InvalidTypeError < ::ArgumentError; end

    def | other
      Camille::Types::Union.new(self, other)
    end

    def []
      Camille::Types::Array.new(self)
    end

    def self.| other
      Camille::Type.instance(self) | other
    end

    def self.[]
      Camille::Type.instance(self)[]
    end

    def self.generic?
      instance_method(:initialize).arity != 0
    end

    def self.instance value
      if value.is_a? Hash
        Camille::Types::Object.new(value)
      elsif value.is_a? Camille::Type
        value
      elsif value.is_a?(Class) && value < Camille::Type && !value.generic?
        value.new
      else
        raise InvalidTypeError.new("#{value} cannot be converted to a type instance.")
      end
    end
  end
end