RSpec.describe Camille::Rendered do
  let(:fingerprint){ Digest::MD5.hexdigest('1') }
  let(:rendered){ described_class.new(fingerprint, '{"a":1}') }

  describe '#to_json' do
    it 'splices the json string verbatim when nested in another structure' do
      expect(JSON.dump({b: [rendered]})).to eq('{"b":[{"a":1}]}')
    end
  end

  describe 'Marshal' do
    it 'stores only the fingerprint and json' do
      expect(rendered.marshal_dump).to eq([fingerprint, '{"a":1}'])
    end

    it 'round-trips' do
      loaded = Marshal.load(Marshal.dump(rendered))
      expect(loaded).to be_an_instance_of(described_class)
      expect(loaded.fingerprint).to eq(fingerprint)
      expect(loaded.json).to eq('{"a":1}')
    end
  end
end
