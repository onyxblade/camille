
RSpec.describe Camille::Types::Number do
  describe '#__check' do
    it 'returns TypeError if value is not a number' do
      number = described_class.new
      expect(number.__check(1)).to be nil
      expect(number.__check(1.1)).to be nil
      expect(number.__check('1')).to be_an_instance_of(Camille::TypeError)
      expect(number.__check('1').basic?).to be true
    end
  end

  describe '#check_value' do
    it 'returns Checked if value is a number' do
      number = described_class.new
      expect(number.check_value(1)).to be_checked
      expect(number.check_value(1.1)).to be_checked
    end

    it 'returns TypeError if value is not a number' do
      number = described_class.new
      expect(number.check_value('1')).to be_basic_type_error
    end
  end
end
