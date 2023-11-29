
RSpec.describe Camille::Types::Intersection do
  describe '#initialize' do
    it "accepts two types" do
      intersection = described_class.new(Camille::Types::Number, Camille::Types::String)
      expect(intersection).to be_an_instance_of(described_class)
    end
  end

  describe '#transform_and_check' do
    let(:intersection_type){
      described_class.new(
        {
          id: Camille::Types::Number
        },
        {
          name: Camille::Types::String
        }
      )
    }

    it 'checks if value is acceptable type' do
      error, transformed = intersection_type.transform_and_check({
        id: 1,
        name: '2'
      })
      expect(error).to be nil
      expect(transformed).to eq({
        id: 1,
        name: '2'
      })
    end

    it 'returns composite error if left-hand side not satisfied' do
      error, transformed = intersection_type.transform_and_check({})

      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('intersection.left')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be false
      expect(error.components.values.first.components.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('id')
      expect(error.components.values.first.components.values.first.message).to eq("Expected an integer or a float, got nil.")
    end

    it 'returns composite error if right-hand side not satisfied' do
      error, transformed = intersection_type.transform_and_check({
        id: 1
      })

      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('intersection.right')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be false
      expect(error.components.values.first.components.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('name')
      expect(error.components.values.first.components.values.first.message).to eq("Expected string, got nil.")
    end

    context 'when two types have conflicting fields' do
      let(:intersection_type) {
        described_class.new(
          {
            id: Camille::Types::Number
          },
          {
            id: Camille::Types::String
          }
        )
      }

      it 'fails at typecheck' do
        error, transformed = intersection_type.transform_and_check({
          id: 1
        })
        expect(error).to be_an_instance_of(Camille::TypeError)
        expect(error.basic?).to be false
        expect(error.components.keys.first).to eq('intersection.right')
        expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
        expect(error.components.values.first.basic?).to be false
        expect(error.components.values.first.components.size).to eq(1)
        expect(error.components.values.first.components.keys.first).to eq('id')
        expect(error.components.values.first.components.values.first.message).to eq("Expected string, got 1.")

        error, transformed = intersection_type.transform_and_check({
          id: '2'
        })
        expect(error).to be_an_instance_of(Camille::TypeError)
        expect(error.basic?).to be false
        expect(error.components.keys.first).to eq('intersection.left')
        expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
        expect(error.components.values.first.basic?).to be false
        expect(error.components.values.first.components.size).to eq(1)
        expect(error.components.values.first.components.keys.first).to eq('id')
        expect(error.components.values.first.components.values.first.message).to eq('Expected an integer or a float, got "2".')
      end
    end

    context 'when intersection has transformable fields' do
      shared_examples 'performing transformation' do
        it 'returns transformed value' do
          time = Time.now

          error, transformed = intersection_type.transform_and_check({
            id: 1,
            name: '2',
            time: time
          })
          expect(error).to be nil
          expect(transformed).to eq({
            id: 1,
            name: '2',
            time: time.as_json
          })
        end

        it 'returns error if transformable field is missing' do
          error, transformed = intersection_type.transform_and_check({
            id: 1,
            name: '2'
          })

          expect(error).to be_an_instance_of(Camille::TypeError)
          expect(error.basic?).to be false
          expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
          expect(error.components.values.first.basic?).to be false
          expect(error.components.values.first.components.size).to eq(1)
          expect(error.components.values.first.components.keys.first).to eq('time')
          expect(error.components.values.first.components.values.first.message).to eq("Expected string, got nil.")
        end

        it 'returns error if transformable field is of wrong type' do
          error, transformed = intersection_type.transform_and_check({
            id: 1,
            name: '2',
            time: 1
          })

          expect(error).to be_an_instance_of(Camille::TypeError)
          expect(error.basic?).to be false
          expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
          expect(error.components.values.first.basic?).to be false
          expect(error.components.values.first.components.size).to eq(1)
          expect(error.components.values.first.components.keys.first).to eq('time')
          expect(error.components.values.first.components.values.first.message).to eq("Expected string, got 1.")
        end
      end

      context 'when transformable value is at the left' do
        let(:intersection_type) {
          described_class.new(
            {
              id: Camille::Types::Number,
              time: Camille::Types::DateTime
            },
            {
              name: Camille::Types::String
            }
          )
        }

        it_behaves_like 'performing transformation'
      end

      context 'when transformable value is at the right' do
        let(:intersection_type) {
          described_class.new(
            {
              id: Camille::Types::Number
            },
            {
              name: Camille::Types::String,
              time: Camille::Types::DateTime
            }
          )
        }

        it_behaves_like 'performing transformation'
      end

      context 'when both sides have transformable value' do
        let(:intersection_type) {
          described_class.new(
            {
              id: Camille::Types::Number,
              time: Camille::Types::DateTime
            },
            {
              name: Camille::Types::String,
              time: Camille::Types::DateTime
            }
          )
        }

        it_behaves_like 'performing transformation'
      end

    end

    context 'when intersection has optional fields' do
      let(:intersection_type) {
        described_class.new(
          {
            id: Camille::Types::Number,
          },
          {
            name?: Camille::Types::String,
          }
        )
      }

      it 'preserves the optional field' do
        error, transformed = intersection_type.transform_and_check({
          id: 1
        })
        expect(error).to be nil
      end
    end
  end

  describe '#literal' do
    let(:intersection) {
      described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )
    }

    let(:intersection_with_union){
      described_class.new(
        Camille::Types::Number,
        Camille::Types::Union.new(
          Camille::Types::String,
          Camille::Types::Boolean
        )
      )
    }

    it 'returns correct literal' do
      expect(intersection.literal).to eq('(number & string)')
    end

    it 'returns correct literal when mixed with union' do
      expect(intersection_with_union.literal).to eq('(number & (string | boolean))')
    end
  end
end
