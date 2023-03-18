
RSpec.describe Camille::Types::Null do
  describe '#check' do
    it 'returns TypeError if value is not nil' do
      null = described_class.new
      expect(null.check(nil)).to be nil
      expect(null.check(false)).to be_an_instance_of(Camille::TypeError)
      expect(null.check(false).basic?).to be true
    end
  end
end
