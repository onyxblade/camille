module Camille
  class Checked
    attr_reader :fingerprint, :value

    def initialize fingerprint, value
      @fingerprint = fingerprint
      @value = value
    end

  end
end