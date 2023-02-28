module Camille
  class TypeStore
    class ArgumentError < ::ArgumentError; end
    class NoTypeError < ::ArgumentError; end

    def initialize
      @map = {}
    end

    def add name, type
      if type <= Camille::Type
        @map[name] = type
      else
        raise ArgumentError.new("A subclass of Camille::Type is expected.")
      end
    end

    def get name
      if found = @map[name]
        found
      else
        raise NoTypeError.new("Cannot find type by name #{name}")
      end
    end
  end
end