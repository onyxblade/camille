
RSpec.describe Camille::Types::Undefined do
  describe '#__check' do
    it 'returns TypeError if value is not nil' do
      number = described_class.new
      expect(number.__check(nil)).to be nil
      expect(number.__check(false)).to be_an_instance_of(Camille::TypeError)
      expect(number.__check(false).basic?).to be true
    end
  end

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
