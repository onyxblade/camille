
RSpec.describe Camille::Types::Any do
  describe '#check' do
    it 'returns checked for any value' do
      any = described_class.new
      expect(any.check(1)).to be_checked
      expect(any.check('string')).to be_checked
      expect(any.check(false)).to be_checked
      expect(any.check([])).to be_checked
      expect(any.check({})).to be_checked
    end
  end
end
