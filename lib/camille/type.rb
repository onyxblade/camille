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

      define_method(:initialize) do
        @underlying = underlying
      end
    end

    def check value
      @underlying.check value
    end

    def self.const_missing name
      Camille::Types.const_get(name)
    end
  end
end