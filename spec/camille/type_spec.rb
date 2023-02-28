
RSpec.describe Camille::Type do
  describe '#|' do
    it 'generates an union type' do
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

  describe '.from_value' do
    it 'converts hash to object type' do
      type = Camille::Type.from_value(id: Camille::Types::Number.new)
      expect(type).to be_an_instance_of(Camille::Types::Object)
    end

    it 'directly returns the type when no conversion needed' do
      type = Camille::Type.from_value(Camille::Types::Number.new)
      expect(type).to be_an_instance_of(Camille::Types::Number)
    end

    it 'raises when value is not a type or a hash' do
      expect{ Camille::Type.from_value 1 }.to raise_error(Camille::Type::InvalidTypeError)
    end
  end
end
