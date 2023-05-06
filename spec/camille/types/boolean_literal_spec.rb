
RSpec.describe Camille::Types::BooleanLiteral do
  describe '#initialize' do
    it 'raises if not given a boolean' do
      expect{described_class.new('1')}.to raise_error(Camille::Types::BooleanLiteral::ArgumentError)
    end

    it 'accepts booleans' do
      expect(described_class.new(true)).to be_an_instance_of(described_class)
      expect(described_class.new(false)).to be_an_instance_of(described_class)
    end
  end

  describe '#check' do
    it 'returns TypeError if value is not the literal' do
      literal = described_class.new(false)
      expect(literal.check(false)).to be nil
      expect(literal.check(1.1)).to be_an_instance_of(Camille::TypeError)
      expect(literal.check(1.1).basic?).to be true
      expect(literal.check('1')).to be_an_instance_of(Camille::TypeError)
      expect(literal.check('1').basic?).to be true
      expect(literal.check(true)).to be_an_instance_of(Camille::TypeError)
      expect(literal.check(true).basic?).to be true
    end
  end

  describe '#literal' do
    it 'returns the correct literal' do
      literal = described_class.new(true)
      expect(literal.literal).to eq('true')
    end
  end
end
