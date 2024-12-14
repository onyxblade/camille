module Camille
  # This class represents all custom types defined by the user.
  class Type < BasicType
    class NotImplementedError < ::NotImplementedError; end

    attr_reader :underlying

    def initialize
      raise NotImplementedError.new("Missing `alias_of` definition for type.")
    end

    def self.alias_of type
      underlying = Camille::Type.instance(type)
      fingerprint = underlying.fingerprint

      define_method(:initialize) do
        @underlying = underlying
        @fingerprint = fingerprint
      end
    end

    def __check value
      @underlying.__check value
    end

    def transform_and_check value
      transformed = transform value
      @underlying.transform_and_check transformed
    end

    def test value
      error, _ = transform_and_check value
      error
    end

    def self.test value
      new.test value
    end

    def self.klass_name
      name.gsub(/^Camille::Types::/, '')
    end

    def literal
      self.class.klass_name.gsub(/::/, '_')
    end

    def self.inherited klass
      Camille::Loader.loaded_types << klass
    end
  end
end