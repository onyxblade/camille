
RSpec.describe Camille::Types::Number do
  describe '#check' do
    it 'returns TypeError if value is not a number' do
      number = described_class.new
      expect(number.check(1)).to be nil
      expect(number.check(1.1)).to be nil
      expect(number.check('1')).to be_an_instance_of(Camille::TypeError)
      expect(number.check('1').basic?).to be true
    end
  end

  describe '#check_value' do
    it 'returns TypeError if value is not a number' do
      number = described_class.new
      expect(number.check(1)).to be nil
      expect(number.check(1.1)).to be nil
      expect(number.check('1')).to be_an_instance_of(Camille::TypeError)
      expect(number.check('1').basic?).to be true
    end
  end
end
