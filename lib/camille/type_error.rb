module Camille
  class TypeError
    class ArgumentError < ::ArgumentError; end

    attr_reader :message, :components

    def initialize message = nil, **components
      if message.is_a? String
        @message = message
      elsif !components.empty?
        @components = components
      else
        raise ArgumentError.new("Expecting one string or one hash.")
      end
    end

    def basic?
      !!@message
    end

    def print io = STDOUT
      Camille::TypeErrorPrinter.new(self).print io
    end
  end
end