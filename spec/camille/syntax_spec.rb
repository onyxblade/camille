using Camille::Syntax

RSpec.describe Camille::Syntax do
  describe 'Hash' do
    it 'returns array type for #[]' do
      array = {id: Camille::Types::Number}[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::Object)
      expect(array.content.fields[:id]).to be_an_instance_of(Camille::Types::Number)
    end

    it 'returns union type for #|' do
      union = {id: Camille::Types::Number} | {name: Camille::Types::String}
      expect(union).to be_an_instance_of(Camille::Types::Union)
      expect(union.left).to be_an_instance_of(Camille::Types::Object)
      expect(union.left.fields[:id]).to be_an_instance_of(Camille::Types::Number)
      expect(union.right).to be_an_instance_of(Camille::Types::Object)
      expect(union.right.fields[:name]).to be_an_instance_of(Camille::Types::String)
    end

    it 'returns intersection type for #&' do
      intersection = {id: Camille::Types::Number} & {name: Camille::Types::String}
      expect(intersection).to be_an_instance_of(Camille::Types::Intersection)
      expect(intersection.left).to be_an_instance_of(Camille::Types::Object)
      expect(intersection.left.fields[:id]).to be_an_instance_of(Camille::Types::Number)
      expect(intersection.right).to be_an_instance_of(Camille::Types::Object)
      expect(intersection.right.fields[:name]).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe 'Array' do
    it 'returns array type for #[]' do
      array = [Camille::Types::Number][]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::Tuple)
      expect(array.content.elements[0]).to be_an_instance_of(Camille::Types::Number)
    end

    it 'returns union type for #|' do
      union = [Camille::Types::Number] | [Camille::Types::String]
      expect(union).to be_an_instance_of(Camille::Types::Union)
      expect(union.left).to be_an_instance_of(Camille::Types::Tuple)
      expect(union.left.elements[0]).to be_an_instance_of(Camille::Types::Number)
      expect(union.right).to be_an_instance_of(Camille::Types::Tuple)
      expect(union.right.elements[0]).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe 'Integer' do
    it 'returns literal type for #[]' do
      array = 1[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::NumberLiteral)
    end

    it 'returns union type for #|' do
      union = 1 | 2
      expect(union).to be_an_instance_of(Camille::Types::Union)
      expect(union.left).to be_an_instance_of(Camille::Types::NumberLiteral)
      expect(union.right).to be_an_instance_of(Camille::Types::NumberLiteral)
    end
  end

  describe 'Float' do
    it 'returns literal type for #[]' do
      array = 1.1[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::NumberLiteral)
    end

    it 'returns union type for #|' do
      union = 1.1 | 2.1
      expect(union).to be_an_instance_of(Camille::Types::Union)
      expect(union.left).to be_an_instance_of(Camille::Types::NumberLiteral)
      expect(union.right).to be_an_instance_of(Camille::Types::NumberLiteral)
    end
  end

  describe 'String' do
    it 'returns literal type for #[]' do
      array = 'str'[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::StringLiteral)
    end

    it 'returns union type for #|' do
      union = '1' | '2'
      expect(union).to be_an_instance_of(Camille::Types::Union)
      expect(union.left).to be_an_instance_of(Camille::Types::StringLiteral)
      expect(union.right).to be_an_instance_of(Camille::Types::StringLiteral)
    end
  end

  describe 'Boolean' do
    shared_examples 'a type' do
      it 'returns literal type for #[]' do
        array = value[]
        expect(array).to be_an_instance_of(Camille::Types::Array)
        expect(array.content).to be_an_instance_of(Camille::Types::BooleanLiteral)
        expect(array.content.value).to eq(value)
      end

      it 'returns union type for #|' do
        union = value | '2'
        expect(union).to be_an_instance_of(Camille::Types::Union)
        expect(union.left).to be_an_instance_of(Camille::Types::BooleanLiteral)
        expect(union.right).to be_an_instance_of(Camille::Types::StringLiteral)
        expect(union.left.value).to eq(value)
      end
    end

    context 'for true' do
      let(:value){ true }
      it_behaves_like 'a type'
    end

    context 'for false' do
      let(:value){ false }
      it_behaves_like 'a type'
    end
  end
end
