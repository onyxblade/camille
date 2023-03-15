module Camille
  # This class represents all custom types defined by the user.
  class Type < BasicType
    class NotImplementedError < ::NotImplementedError; end
    include Camille::Types

    attr_reader :underlying

    def initialize
      raise NotImplementedError.new("Missing `alias_of` definition for type.")
    end

    def self.alias_of type
      underlying = Camille::Type.instance(type)

      define_method(:initialize) do
        @underlying = underlying
      end
    end

    def check value
      @underlying.check value
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