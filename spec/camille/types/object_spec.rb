
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

  describe '#check' do
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
      result = object_type.check({
        id: 1,
        name: 'name'
      })
      expect(result).to have_checked_value({
        id: 1,
        name: 'name'
      })
    end

    it 'returns basic error if value is not a hash' do
      error = object_type.check(1)
      expect(error).to be_basic_type_error
    end

    it 'returns composite error if value is a hash' do
      error = object_type.check({
        id: 1,
        name: 2
      })

      expect(error).to be_composite_type_error
      expect(error.components.keys.first).to eq('name')
      expect(error.components.values.first).to be_basic_type_error
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

      it 'returns checked values' do
        result = nested_object_type.check({
          product: {
            id: 1,
            name: '2'
          }
        })
        expect(result).to have_checked_value({
          product: {
            id: 1,
            name: '2'
          }
        })
      end

      it 'returns errors for nested object' do
        error = nested_object_type.check({
          product: {
            id: 1,
            name: 2
          }
        })
        expect(error).to be_composite_type_error
        expect(error.components.keys.first).to eq('product')

        nested_error = error.components.values.first
        expect(nested_error).to be_composite_type_error
        expect(nested_error.components.keys.first).to eq('name')
        expect(nested_error.components.values.first).to be_basic_type_error
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
        result = optional_object_type.check({})
        expect(result).to have_checked_value({})
      end

      it 'returns composite error if optional fields are of wrong type' do
        error = optional_object_type.check({
          id: '1'
        })
        expect(error).to be_composite_type_error
        expect(error.components.keys.first).to eq('id')
        expect(error.components.values.first).to be_basic_type_error
        expect(error.components.values.first.message).to eq('Expected an integer or a float, got "1".')
      end

      it 'removes optional fields if passed nil' do
        result = optional_object_type.check({id: nil, name: nil})
        expect(result).to have_checked_value({})
      end
    end

    it 'returns transformed value for date' do
      time = Time.now
      result = object_type_with_date.check({
        id: 1,
        date: time
      })

      expect(result).to have_checked_value({
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

      result = type.check({
        nested: {
          date: time
        }
      })
      expect(result).to have_checked_value({
        nested: {
          date: time.as_json
        }
      })
    end

    it 'preserves fields that are not in object schema' do
      result = object_type.check({
        id: 1,
        name: 'a',
        other: 'c'
      })
      expect(result).to be_checked
      expect(result.value[:other]).to eq('c')
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
