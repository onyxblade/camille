
RSpec.describe Camille::ObjectHash do
  describe '#as_json' do
    it 'performs key conversion' do
      object_hash = described_class[{
        long_name: 1
      }]

      expect(object_hash.as_json).to eq({'longName' => 1})
    end
  end

  describe '.[]' do
    it 'does not intervene nested hashs' do
      object_hash = described_class[{
        object: {
          id: 1
        }
      }]

      expect(object_hash.class).to be described_class
      expect(object_hash[:object].class).to be Hash
    end
  end
end