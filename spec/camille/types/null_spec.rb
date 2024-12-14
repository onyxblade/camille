
RSpec.describe Camille::Types::Null do
  describe '#check' do
    it 'returns TypeError if value is not nil' do
      null = described_class.new
      expect(null.check(nil)).to be nil
      expect(null.check(false)).to be_an_instance_of(Camille::TypeError)
      expect(null.check(false).basic?).to be true
    end
  end

  describe '#check_value' do
    it 'returns Checked if value is not nil' do
      null = described_class.new
      expect(null.check_value(nil)).to be_checked
    end

    it 'returns TypeError if value is not nil' do
      null = described_class.new
      expect(null.check_value(false)).to be_basic_type_error
    end
  end
end
