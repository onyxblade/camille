
RSpec.describe Camille::Types::Any do
  describe '#check' do
    it 'returns nil for any value' do
      any = described_class.new
      expect(any.check(1)).to be nil
      expect(any.check('string')).to be nil
      expect(any.check(false)).to be nil
      expect(any.check([])).to be nil
      expect(any.check({})).to be nil
    end
  end
end
