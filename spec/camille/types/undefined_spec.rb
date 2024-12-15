
RSpec.describe Camille::Types::Undefined do
  describe '#check' do
    it 'returns Checked if value is nil' do
      undefined = described_class.new
      expect(undefined.check(nil)).to be_checked
    end

    it 'returns TypeError if value is not nil' do
      undefined = described_class.new
      expect(undefined.check(false)).to be_basic_type_error
    end
  end
end
