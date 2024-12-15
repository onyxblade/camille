
RSpec.describe Camille::Types::Number do
  describe '#check' do
    it 'returns Checked if value is a number' do
      number = described_class.new
      expect(number.check(1)).to be_checked
      expect(number.check(1.1)).to be_checked
    end

    it 'returns TypeError if value is not a number' do
      number = described_class.new
      expect(number.check('1')).to be_basic_type_error
    end
  end
end
