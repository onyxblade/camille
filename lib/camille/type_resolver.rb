module Camille
  class TypeResolver < Object
    def initialize type_store
      @type_store = type_store
    end

    def eval &block
      instance_exec &block
    end

    def method_missing name, *args
      @type_store.get(name).new *args
    end
  end
end