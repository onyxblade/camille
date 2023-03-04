module Camille
  # This class specifies the methods available for all types includeing built-in and custom ones.
  class BasicType
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

    def self.directly_instantiable?
      instance_method(:initialize).arity == 0
    end

    def self.instance value
      if value.is_a? ::Hash
        Camille::Types::Object.new(value)
      elsif value.is_a? ::Array
        Camille::Types::Tuple.new(value)
      elsif value.is_a? Camille::BasicType
        value
      elsif value.is_a?(Class) && value < Camille::BasicType && value.directly_instantiable?
        value.new
      else
        raise InvalidTypeError.new("#{value} cannot be converted to a type instance.")
      end
    end
  end
end