
RSpec.describe Camille::Types::Boolean do
  describe '#check' do
    it 'returns TypeError if value is not a boolean' do
      number = described_class.new
      expect(number.check(true)).to be nil
      expect(number.check(false)).to be nil
      expect(number.check(1)).to be_an_instance_of(Camille::TypeError)
      expect(number.check(1).basic?).to be true
    end
  end
end
