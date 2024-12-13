
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

    it 'raises when given unsafe keys' do
      expect{
        Camille::Types::Object.new(
          address_line_1: Camille::Types::String
        )
      }.to raise_error(Camille::Types::Object::ArgumentError)
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
        date: Camille::Types::DateTime
      )
    }
    let(:time) { Time.now }

    it 'checks if value is correct object type' do
      error, transformed = object_type.transform_and_check({
        id: 1,
        name: 'name'
      })
      expect(error).to be nil
      expect(transformed).to eq({
        id: 1,
        name: 'name'
      })
    end

    it 'returns basic error if value is not a hash' do
      error, transformed = object_type.transform_and_check(1)
      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be true
    end

    it 'returns composite error if value is a hash' do
      error, transformed = object_type.transform_and_check({
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

      it 'returns transformed values' do
        error, transformed = nested_object_type.transform_and_check({
          product: {
            id: 1,
            name: '2'
          }
        })
        expect(error).to be nil
        expect(transformed).to eq({
          product: {
            id: 1,
            name: '2'
          }
        })
      end

      it 'returns errors for nested object' do
        error, transformed = nested_object_type.transform_and_check({
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
        error, transformed = optional_object_type.transform_and_check({})
        expect(error).to be nil
        expect(transformed).to eq({})
      end

      it 'returns composite error if optional fields are of wrong type' do
        error, transformed = optional_object_type.transform_and_check({
          id: '1'
        })
        expect(error).to be_an_instance_of(Camille::TypeError)
        expect(error.basic?).to be false
        expect(error.components.keys.first).to eq('id')
        expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
        expect(error.components.values.first.message).to eq('Expected an integer or a float, got "1".')
      end

      it 'removes optional fields if passed nil' do
        error, transformed = optional_object_type.transform_and_check({id: nil, name: nil})
        expect(error).to be nil
        expect(transformed).to eq({})
      end
    end

    it 'returns transformed value for date' do
      time = Time.now
      _, transformed = object_type_with_date.transform_and_check({
        id: 1,
        date: time
      })

      expect(transformed).to eq({
        id: 1,
        date: time.as_json
      })
    end

    it 'returns nested transformed values' do
      type = described_class.new(
        nested: {
          date: Camille::Types::DateTime
        }
      )

      errors, transformed = type.transform_and_check({
        nested: {
          date: time
        }
      })
      expect(errors).to be nil
      expect(transformed).to eq({
        nested: {
          date: time.as_json
        }
      })
    end

    it 'preserves fields that are not in object schema' do
      errors, transformed = object_type.transform_and_check({
        id: 1,
        name: 'a',
        other: 'c'
      })
      expect(transformed[:other]).to eq('c')
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

    it 'preserves optional fields' do
      object = described_class.new(
        optional?: Camille::Types::Number
      )
      expect(object.literal).to eq('{optional?: number}')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on fields regardless of order' do
      object_a = described_class.new(
        id: Camille::Types::Number,
        name: Camille::Types::String
      )

      object_a1 = described_class.new(
        name: Camille::Types::String,
        id: Camille::Types::Number
      )

      object_b = described_class.new(
        id: Camille::Types::Number,
      )

      expect(object_a.fingerprint).to eq(object_a1.fingerprint)
      expect(object_a.fingerprint).not_to eq(object_b.fingerprint)
    end

    it 'returns different fingerprint based on optional fields' do
      object_a = described_class.new(
        id: Camille::Types::Number,
        name: Camille::Types::String
      )

      object_b = described_class.new(
        id: Camille::Types::Number,
        name?: Camille::Types::String
      )

      expect(object_a.fingerprint).not_to eq(object_b.fingerprint)
    end

    it 'returns fingerprint based on optional fields regardless of order' do
      object_a = described_class.new(
        id?: Camille::Types::Number,
        name?: Camille::Types::String
      )

      object_a1 = described_class.new(
        name?: Camille::Types::String,
        id?: Camille::Types::Number
      )

      expect(object_a.fingerprint).to eq(object_a1.fingerprint)
    end
  end
end
