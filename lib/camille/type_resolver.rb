module Camille
  class TypeResolver < Object
    class NoMethodError < ::NoMethodError; end

    def initialize type_store
      @type_store = type_store
    end

    def eval &block
      instance_exec &block
    end

    def method_missing name, *args
      @type_store.get(name).new *args
    rescue Camille::TypeStore::NoTypeError
      raise NoMethodError.new("Undefined method `#{name}`.")
    end
  end
end