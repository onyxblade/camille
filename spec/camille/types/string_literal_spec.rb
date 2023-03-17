
RSpec.describe Camille::Types::StringLiteral do
  describe '#initialize' do
    it 'raises if not given a number' do
      expect{described_class.new(1)}.to raise_error(Camille::Types::StringLiteral::ArgumentError)
    end
  end

  describe '#check' do
    it 'returns TypeError if value is not the literal' do
      literal = described_class.new('1')
      expect(literal.check('1')).to be nil
      expect(literal.check('2')).to be_an_instance_of(Camille::TypeError)
      expect(literal.check('2').basic?).to be true
      expect(literal.check(1)).to be_an_instance_of(Camille::TypeError)
      expect(literal.check(1).basic?).to be true
    end
  end

  describe '#literal' do
    it 'returns the correct literal' do
      literal = described_class.new('1')
      expect(literal.literal).to eq('"1"')
    end
  end
end
