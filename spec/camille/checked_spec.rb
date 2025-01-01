
RSpec.describe Camille::Checked do
  describe '#render' do
    let(:fingerprint){ Digest::MD5.hexdigest('1') }
    let(:checked){ described_class.new(fingerprint, {a: 1}) }
    let(:rendered) { checked.render }

    it 'returns rendered object' do
      expect(rendered).to be_an_instance_of(Camille::Rendered)
      expect(rendered.fingerprint).to eq(fingerprint)
      expect(rendered.json).to eq('{"a":1}')
    end
  end
end