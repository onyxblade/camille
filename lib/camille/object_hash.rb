module Camille
  class ObjectHash < Hash
    def as_json options = nil
      transform_keys{|k, _| Camille::KeyConverter.convert_response_key(k)}.as_json
    end

    def to_json options = nil
      as_json.to_json
    end
  end
end