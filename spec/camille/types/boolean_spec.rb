
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

  describe '#check_value' do
    it 'returns Checked if value is a boolean' do
      boolean = described_class.new
      expect(boolean.check_value(true)).to be_checked
      expect(boolean.check_value(false)).to be_checked
    end

    it 'returns TypeError if value is not a boolean' do
      boolean = described_class.new
      expect(boolean.check(1)).to be_basic_type_error
    end
  end
end
