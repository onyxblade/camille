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

    def inspect
      string_io = StringIO.new
      Camille::TypeErrorPrinter.new(self).print string_io
      "#<Camille::TypeError\n#{string_io.string}>"
    end

    def to_s
      inspect
    end

    def checked?
      false
    end

    def type_error?
      true
    end
  end
end