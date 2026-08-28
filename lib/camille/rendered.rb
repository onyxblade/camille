module Camille
  # A JSON string that has already passed a type check for the type identified by
  # `fingerprint`. Any type will accept a `Rendered` with a matching fingerprint
  # without re-checking it, and `to_json` splices the string verbatim, so a
  # `Rendered` can be stored (e.g. in `Rails.cache`) and placed into a later
  # response as an opaque, immutable fragment.
  class Rendered
    attr_reader :fingerprint, :json

    def initialize fingerprint, json
      @fingerprint = fingerprint
      @json = json
    end

    def to_json options = nil
      @json
    end

    # Marshal (and therefore the default `Rails.cache` coder) stores only the two
    # strings, so cached entries stay valid across changes to this class's
    # internals.
    def marshal_dump
      [@fingerprint, @json]
    end

    def marshal_load array
      @fingerprint, @json = array
    end
  end
end
