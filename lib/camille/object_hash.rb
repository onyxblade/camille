module Camille
  class ObjectHash < Hash
    def to_json options = nil
      JSON.dump(transform_keys{|k, _| Camille::KeyConverter.convert_response_key(k)})
    end
  end
end