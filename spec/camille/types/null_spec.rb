
RSpec.describe Camille::Types::Null do
  describe '#check' do
    it 'returns Checked if value is not nil' do
      null = described_class.new
      expect(null.check(nil)).to be_checked
    end

    it 'returns TypeError if value is not nil' do
      null = described_class.new
      expect(null.check(false)).to be_basic_type_error
    end
  end
end
