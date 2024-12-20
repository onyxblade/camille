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

    def check value
      normalized = transform value
      @underlying.check normalized
    end

    def test value
      result = check value
      result.type_error? ? result : nil
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