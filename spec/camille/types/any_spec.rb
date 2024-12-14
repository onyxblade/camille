
RSpec.describe Camille::Types::Any do
  describe '#check_value' do
    it 'returns checked for any value' do
      any = described_class.new
      expect(any.check_value(1)).to be_checked
      expect(any.check_value('string')).to be_checked
      expect(any.check_value(false)).to be_checked
      expect(any.check_value([])).to be_checked
      expect(any.check_value({})).to be_checked
    end
  end
end
