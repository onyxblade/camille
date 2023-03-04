
class Camille::Types::TypeSpec < Camille::Type
  alias_of(Number)
end

class Camille::Types::TypeSpec::Nested < Camille::Type
  alias_of(
    id: Number,
    name: String
  )
end

RSpec.describe Camille::Type do
  describe '.alias_of' do
    it 'defines type alias' do
      expect(Camille::Types::TypeSpec.new.underlying).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#check' do
    it 'uses the underlying type to check' do
      expect(Camille::Types::TypeSpec.new.check(1)).to be nil
      expect(Camille::Types::TypeSpec.new.check('1')).to be_an_instance_of(Camille::TypeError)
    end
  end

  describe '#directly_instantiable?' do
    it 'returns true' do
      expect(Camille::Types::TypeSpec.directly_instantiable?).to be true
    end
  end

  describe '#initialize' do
    it 'raises if no `alias_of` definition available' do
      expect{Class.new(Camille::Type).new}.to raise_error(Camille::Type::NotImplementedError)
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      expect(Camille::Types::TypeSpec.new.literal).to eq('TypeSpec')
      expect(Camille::Types::TypeSpec::Nested.new.literal).to eq('TypeSpec_Nested')
    end
  end
end
