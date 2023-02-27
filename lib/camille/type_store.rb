module Camille
  class TypeStore
    class ArgumentError < ::ArgumentError; end

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
      @map[name]
    end
  end
end