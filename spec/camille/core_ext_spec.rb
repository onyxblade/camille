using Camille::CoreExt

RSpec.describe Camille::CoreExt do
  describe 'Hash' do
    it 'returns array type for #[]' do
      array = {id: Camille::Types::Number.new}[]
      expect(array).to be_an_instance_of(Camille::Types::Array)
      expect(array.content).to be_an_instance_of(Camille::Types::Object)
      expect(array.content.fields[:id]).to be_an_instance_of(Camille::Types::Number)
    end

    it 'returns union type for #|' do
      union = {id: Camille::Types::Number.new} | {name: Camille::Types::String.new}
      expect(union).to be_an_instance_of(Camille::Types::Union)
      expect(union.left).to be_an_instance_of(Camille::Types::Object)
      expect(union.left.fields[:id]).to be_an_instance_of(Camille::Types::Number)
      expect(union.right).to be_an_instance_of(Camille::Types::Object)
      expect(union.right.fields[:name]).to be_an_instance_of(Camille::Types::String)
    end
  end
end
