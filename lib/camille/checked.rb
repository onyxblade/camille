module Camille
  class Checked
    attr_reader :fingerprint, :value

    def initialize fingerprint, value
      @fingerprint = fingerprint
      @value = value
    end

    def checked?
      true
    end

    def type_error?
      false
    end

    def render
      if @value.instance_of? Camille::Rendered
        @value
      else
        Camille::Rendered.new(@fingerprint, JSON.dump(@value))
      end
    end
  end
end