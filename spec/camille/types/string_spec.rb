
RSpec.describe Camille::Types::String do
  describe '#check' do
    it 'returns Checked if value is a string or a symbol' do
      string = described_class.new
      expect(string.check('string')).to be_checked
      expect(string.check(:symbol)).to be_checked
    end

    it 'returns TypeError if value is not a string or a symbol' do
      string = described_class.new
      expect(string.check(1)).to be_basic_type_error
    end
  end
end
