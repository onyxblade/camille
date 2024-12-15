require 'digest/md5'

module Camille
  # This class specifies the methods available for all types includeing built-in and custom ones.
  class BasicType
    class InvalidTypeError < ::ArgumentError; end

    attr_reader :fingerprint

    def initialize
      @fingerprint = Digest::MD5.hexdigest self.class.name
    end

    def | other
      Camille::Types::Union.new(self, other)
    end

    def & other
      Camille::Types::Intersection.new(self, other)
    end

    def []
      Camille::Types::Array.new(self)
    end

    def transform value
      value
    end

    def self.| other
      Camille::Type.instance(self) | other
    end

    def self.& other
      Camille::Type.instance(self) & other
    end

    def self.[]
      Camille::Type.instance(self)[]
    end

    def self.directly_instantiable?
      instance_method(:initialize).arity == 0
    end

    def self.instance value
      case
      when value.is_a?(::Hash)
        Camille::Types::Object.new(value)
      when value.is_a?(::Array)
        Camille::Types::Tuple.new(value)
      when value.is_a?(Integer) || value.is_a?(Float)
        Camille::Types::NumberLiteral.new(value)
      when value.is_a?(::String)
        Camille::Types::StringLiteral.new(value)
      when value == true || value == false
        Camille::Types::BooleanLiteral.new(value)
      when value.is_a?(Camille::BasicType)
        value
      when value.is_a?(Class) && value < Camille::BasicType && value.directly_instantiable?
        value.new
      else
        raise InvalidTypeError.new("#{value} cannot be converted to a type instance.")
      end
    end
  end
end