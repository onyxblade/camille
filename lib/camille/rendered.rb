module Camille
  class Rendered
    attr_reader :fingerprint, :json

    def initialize fingerprint, json
      @fingerprint = fingerprint
      @json = json
    end

    def to_json options = nil
      @json
    end
  end
end