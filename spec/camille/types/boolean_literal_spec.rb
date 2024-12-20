
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
    it 'returns Checked if value is the literal' do
      literal = described_class.new(false)
      expect(literal.check(false)).to be_checked
    end

    it 'returns TypeError if value is not the literal' do
      literal = described_class.new(false)
      expect(literal.check(1.1)).to be_basic_type_error
      expect(literal.check('1')).to be_basic_type_error
      expect(literal.check(true)).to be_basic_type_error
    end
  end

  describe '#literal' do
    it 'returns the correct literal' do
      literal = described_class.new(true)
      expect(literal.literal).to eq('true')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on value' do
      literal_a = described_class.new(true)
      literal_a1 = described_class.new(true)
      literal_b = described_class.new(false)

      expect(literal_a.fingerprint).to eq(literal_a1.fingerprint)
      expect(literal_a.fingerprint).not_to eq(literal_b.fingerprint)
    end
  end
end
