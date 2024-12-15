
RSpec.describe Camille::Types::Boolean do
  describe '#check' do
    it 'returns Checked if value is a boolean' do
      boolean = described_class.new
      expect(boolean.check(true)).to be_checked
      expect(boolean.check(false)).to be_checked
    end

    it 'returns TypeError if value is not a boolean' do
      boolean = described_class.new
      expect(boolean.check(1)).to be_basic_type_error
    end
  end
end
