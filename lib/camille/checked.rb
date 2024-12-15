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
  end
end