module Camille
  class KeyConverter
    class << self
      RESPONSE_KEY_CACHE = {}

      def convert_response_key key
        if in_cache = RESPONSE_KEY_CACHE[key]
          in_cache
        else
          RESPONSE_KEY_CACHE[key] = Camille::Configuration.response_key_converter.call(key.to_s)
        end
      end

      def convert_params_key key
        Camille::Configuration.params_key_converter.call(key)
      end
    end
  end
end