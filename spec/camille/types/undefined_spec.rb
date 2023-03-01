
RSpec.describe Camille::Types::Undefined do
  describe '#check' do
    it 'returns TypeError if value is not nil' do
      number = described_class.new
      expect(number.check(nil)).to be nil
      expect(number.check(false)).to be_an_instance_of(Camille::TypeError)
      expect(number.check(false).basic?).to be true
    end
  end
end
