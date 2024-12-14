
RSpec.describe Camille::Types::String do
  describe '#__check' do
    it 'returns TypeError if value is not a string or a symbol' do
      string = described_class.new
      expect(string.__check('string')).to be nil
      expect(string.__check(1)).to be_an_instance_of(Camille::TypeError)
      expect(string.__check(1).basic?).to be true
      expect(string.__check(:symbol)).to be nil
    end
  end

  describe '#__check' do
    it 'returns Checked if value is a string or a symbol' do
      string = described_class.new
      expect(string.check('string')).to be_checked
      expect(string.check(:symbol)).to be_checked
    end

    it 'returns TypeError if value is not a string or a symbol' do
      string = described_class.new
      expect(string.__check(1)).to be_basic_type_error
    end
  end
end
