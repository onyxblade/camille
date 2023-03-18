require 'camille/custom_types/date'

RSpec.describe Camille::Types::Object do
  describe '#initialize' do
    it 'accepts a hash of fields' do
      object = Camille::Types::Object.new(
        id: Camille::Types::Number,
        name: Camille::Types::String
      )
      expect(object.fields[:id]).to be_an_instance_of(Camille::Types::Number)
      expect(object.fields[:name]).to be_an_instance_of(Camille::Types::String)
    end

    it 'deeply converts hash fields to objects' do
      object = Camille::Types::Object.new(
        product: {
          id: Camille::Types::Number,
          price: {
            regular: Camille::Types::Number,
          }
        }
      )

      expect(object.fields[:product]).to be_an_instance_of(Camille::Types::Object)
      expect(object.fields[:product].fields[:price]).to be_an_instance_of(Camille::Types::Object)
      expect(object.fields[:product].fields[:price].fields[:regular]).to be_an_instance_of(Camille::Types::Number)
    end

    it 'creates union type with undefined for all keys ending with ?' do
      object = Camille::Types::Object.new(
        id?: Camille::Types::Number
      )

      expect(object.fields[:id]).to be_an_instance_of(Camille::Types::Union)
      expect(object.fields[:id].left).to be_an_instance_of(Camille::Types::Number)
      expect(object.fields[:id].right).to be_an_instance_of(Camille::Types::Undefined)
    end
  end

  describe '#check' do
    let(:object_type){
      described_class.new(
        id: Camille::Types::Number,
        name: Camille::Types::String
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

    it 'returns composite error if value is a hash' do
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

    context 'when object has nested fields' do
      let(:nested_object_type){
        described_class.new(
          product: {
            id: Camille::Types::Number,
            name: Camille::Types::String
          }
        )
      }

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

    context 'when object has optional fields' do
      let(:optional_object_type){
        described_class.new(
          id?: Camille::Types::Number,
          name?: Camille::Types::String
        )
      }

      it 'checks if optional fields are nil' do
        expect(optional_object_type.check({})).to be nil
      end

      it 'returns composite error if optional fields are of wrong type' do
        error = optional_object_type.check({
          id: '1'
        })
        expect(error).to be_an_instance_of(Camille::TypeError)
        expect(error.basic?).to be false
        expect(error.components.keys.first).to eq('id')
        expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
        expect(error.components.values.first.components.keys).to eq(['union.left', 'union.right'])
      end
    end
  end

  describe '#transform_and_check' do
    let(:object_type){
      described_class.new(
        id: Camille::Types::Number,
        name: Camille::Types::String
      )
    }
    let(:nested_object_type){
      described_class.new(
        product: {
          id: Camille::Types::Number,
          name: Camille::Types::String
        }
      )
    }
    let(:object_type_with_date){
      described_class.new(
        id: Camille::Types::Number,
        date: Camille::CustomTypes::Date
      )
    }

    it 'returns transformed value' do
      _, transformed = object_type.transform_and_check({
        id: 1,
        name: 'name'
      })

      expect(transformed).to eq({
        id: 1,
        name: 'name'
      })
    end

    it 'returns transformed value for nested fields' do
      _, transformed = nested_object_type.transform_and_check({
        product: {
          id: 1,
          name: 'name'
        }
      })

      expect(transformed).to eq({
        product: {
          id: 1,
          name: 'name'
        }
      })
    end

    it 'returns transformed value for date' do
      time = Time.now
      _, transformed = object_type_with_date.transform_and_check({
        id: 1,
        date: time
      })

      expect(transformed).to eq({
        id: 1,
        date: {
          type: 'Date',
          value: time.to_i * 1000
        }
      })
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      object = described_class.new(
        id: Camille::Types::Number,
        name: Camille::Types::String
      )
      expect(object.literal).to eq('{id: number, name: string}')
    end

    it 'returns correct literal when nested' do
      object = described_class.new(
        product: {
          id: Camille::Types::Number,
          name: Camille::Types::String
        }
      )
      expect(object.literal).to eq('{product: {id: number, name: string}}')
    end

    it 'camelize keys' do
      object = described_class.new(
        order_product: {
          long_name: Camille::Types::Number
        }
      )
      expect(object.literal).to eq('{orderProduct: {longName: number}}')
    end
  end
end
