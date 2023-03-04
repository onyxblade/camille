
RSpec.describe Camille::BasicType do
  describe '#|' do
    it 'generates a union type' do
      union = Camille::Types::Number.new | Camille::Types::String.new
      expect(union.left).to be_an_instance_of(Camille::Types::Number)
      expect(union.right).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#[]' do
    it 'generates an array type' do
      array = Camille::Types::Number.new[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '.|' do
    it 'generates a union type' do
      union = Camille::Types::Number | Camille::Types::String
      expect(union.left).to be_an_instance_of(Camille::Types::Number)
      expect(union.right).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '.[]' do
    it 'generates an array type' do
      array = Camille::Types::Number[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#directly_instantiable?' do
    it 'returns true when #initialize takes arguments' do
      expect(Camille::Types::Number.directly_instantiable?).to be true
      expect(Camille::Types::Array.directly_instantiable?).to be false
    end
  end

  describe '.instance' do
    it 'converts hash to object type' do
      type = Camille::Type.instance(id: Camille::Types::Number)
      expect(type).to be_an_instance_of(Camille::Types::Object)
    end

    it 'converts array to tuple type' do
      type = Camille::Type.instance([Camille::Types::Number])
      expect(type).to be_an_instance_of(Camille::Types::Tuple)
    end

    it 'directly returns the type when no conversion needed' do
      type = Camille::Type.instance(Camille::Types::Number.new)
      expect(type).to be_an_instance_of(Camille::Types::Number)
    end

    it 'raises when value is not a type or a hash' do
      expect{ Camille::Type.instance 1 }.to raise_error(Camille::Type::InvalidTypeError)
    end

    it 'converts a non-generic type class to type instance' do
      expect(Camille::Type.instance(Camille::Types::Number)).to be_an_instance_of(Camille::Types::Number)
    end

    it 'raises when receiving a generic type class' do
      expect{ Camille::Type.instance Camille::Types::Array }.to raise_error(Camille::Type::InvalidTypeError)
    end
  end
end
