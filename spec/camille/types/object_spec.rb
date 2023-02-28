
RSpec.describe Camille::Types::Object do
  describe '#initialize' do
    it 'accepts a hash of fields' do
      object = Camille::Types::Object.new(
        id: Camille::Types::Number.new,
        name: Camille::Types::String.new
      )
      expect(object.fields[:id]).to be_an_instance_of(Camille::Types::Number)
      expect(object.fields[:name]).to be_an_instance_of(Camille::Types::String)
    end

    it 'deeply converts hash fields to objects' do
      object = Camille::Types::Object.new(
        product: {
          id: Camille::Types::Number.new,
          price: {
            regular: Camille::Types::Number.new,
          }
        }
      )

      expect(object.fields[:product]).to be_an_instance_of(Camille::Types::Object)
      expect(object.fields[:product].fields[:price]).to be_an_instance_of(Camille::Types::Object)
      expect(object.fields[:product].fields[:price].fields[:regular]).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#check' do
    let(:object_type){
      described_class.new(
        id: Camille::Types::Number.new,
        name: Camille::Types::String.new
      )
    }
    let(:nested_object_type){
      described_class.new(
        product: {
          id: Camille::Types::Number.new,
          name: Camille::Types::String.new
        }
      )
    }

    it 'checks if value is correct object type' do
      expect(object_type.check({
        id: 1,
        name: 'name'
      })).to be nil
    end

    it 'returns basic error if value is not a hash' do
      expect(object_type.check(1)).to be_an_instance_of(Camille::TypeError)
      expect(object_type.check(1).basic?).to be true
    end

    it 'returns composite error if value is an array' do
      error = object_type.check({
        id: 1,
        name: 2
      })
      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('name')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be true
    end

    it 'returns errors for nested object' do
      error = nested_object_type.check({
        product: {
          id: 1,
          name: 2
        }
      })
      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('product')

      nested_error = error.components.values.first
      expect(nested_error).to be_an_instance_of(Camille::TypeError)
      expect(nested_error.basic?).to be false
      expect(nested_error.components.keys.first).to eq('name')
      expect(nested_error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(nested_error.components.values.first.basic?).to be true
    end
  end

end
