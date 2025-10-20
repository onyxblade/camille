require 'digest/md5'

module Camille
  # This class specifies the methods available for all types includeing built-in and custom ones.
  class BasicType
    class InvalidTypeError < ::ArgumentError; end

    module CheckRendered
      def check value
        if value.instance_of? Camille::Rendered
          if @fingerprint == value.fingerprint
            Camille::Checked.new(@fingerprint, value)
          else
            Camille::TypeError.new("Expected `Rendered` object with fingerprint #{@fingerprint}. Got fingerprint #{value.fingerprint}.")
          end
        else
          super
        end
      end
    end

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

    def check value
      raise NotImplementedError
    end

    def check_params value
      check value
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

    def self.check_params value
      Camille::Type.instance(self).check_params value
    end

    def self.directly_instantiable?
      instance_method(:initialize).arity == 0
    end

    def self.inherited klass
      klass.prepend CheckRendered
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