
RSpec.xdescribe Camille::Types::Intersection do
  describe '#initialize' do
    it "accepts two types" do
      intersection = described_class.new(Camille::Types::Number, Camille::Types::Number)
      expect(intersection).to be_an_instance_of(described_class)
    end
  end

  describe '#check' do
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
      result = intersection_type.check({
        id: 1,
        name: '2'
      })
      expect(result).to have_checked_value({
        id: 1,
        name: '2'
      })
    end

    it 'returns composite error if left-hand side not satisfied' do
      error = intersection_type.check({})

      expect(error).to be_composite_type_error
      expect(error.components.keys.first).to eq('intersection.left')
      expect(error.components.values.first).to be_composite_type_error
      expect(error.components.values.first.components.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('id')
      expect(error.components.values.first.components.values.first.message).to eq("Expected an integer or a float, got nil.")
    end

    it 'returns composite error if right-hand side not satisfied' do
      error = intersection_type.check({
        id: 1
      })

      expect(error).to be_composite_type_error
      expect(error.components.keys.first).to eq('intersection.right')
      expect(error.components.values.first).to be_composite_type_error
      expect(error.components.values.first.components.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('name')
      expect(error.components.values.first.components.values.first.message).to eq("Expected string, got nil.")
    end

    xcontext 'when two types have conflicting fields' do
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
        error = intersection_type.check({
          id: 1
        })
        expect(error).to be_composite_type_error
        expect(error.components.keys.first).to eq('intersection.right')
        expect(error.components.values.first).to be_composite_type_error
        expect(error.components.values.first.components.size).to eq(1)
        expect(error.components.values.first.components.keys.first).to eq('id')
        expect(error.components.values.first.components.values.first.message).to eq("Expected string, got 1.")

        error = intersection_type.check({
          id: '2'
        })
        expect(error).to be_composite_type_error
        expect(error.components.keys.first).to eq('intersection.left')
        expect(error.components.values.first).to be_composite_type_error
        expect(error.components.values.first.components.size).to eq(1)
        expect(error.components.values.first.components.keys.first).to eq('id')
        expect(error.components.values.first.components.values.first.message).to eq('Expected an integer or a float, got "2".')
      end
    end

    context 'when intersection has transformable fields' do
      shared_examples 'performing transformation' do
        it 'returns transformed value' do
          time = Time.now

          result = intersection_type.check({
            id: 1,
            name: '2',
            time: time
          })
          expect(result).to have_checked_value({
            id: 1,
            name: '2',
            time: time.as_json
          })
        end

        it 'returns error if transformable field is missing' do
          error = intersection_type.check({
            id: 1,
            name: '2'
          })

          expect(error).to be_composite_type_error
          expect(error.components.values.first).to be_composite_type_error
          expect(error.components.values.first.components.size).to eq(1)
          expect(error.components.values.first.components.keys.first).to eq('time')
          expect(error.components.values.first.components.values.first.message).to eq("Expected string, got nil.")
        end

        it 'returns error if transformable field is of wrong type' do
          error = intersection_type.check({
            id: 1,
            name: '2',
            time: 1
          })

          expect(error).to be_composite_type_error
          expect(error.components.values.first).to be_composite_type_error
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
        result = intersection_type.check({
          id: 1
        })
        expect(result).to be_checked
      end
    end

    context 'when intersection contains object of the same name on both sides' do
      let(:intersection_type) {
        described_class.new(
          {
            object: {
              id: Camille::Types::Number,
            }
          },
          {
            object: {
              name: Camille::Types::String,
            }
          }
        )
      }

      it 'perform type checks correctly' do
        result = intersection_type.check({
          object: {
            id: 1,
            name: '2',
          }
        })
        expect(result).to be_checked

        error = intersection_type.check({
          object: {
            id: 1,
          }
        })

        expect(error).to be_composite_type_error
        expect(error.components.values.first).to be_composite_type_error
        expect(error.components.values.first.components.size).to eq(1)
        expect(error.components.values.first.components.keys.first).to eq('object')
        expect(error.components.values.first.components.values.first.components.keys.first).to eq('name')
        expect(error.components.values.first.components.values.first.components.values.first.message).to eq("Expected string, got nil.")
      end
    end
  end

  describe '#literal' do
    let(:intersection) {
      described_class.new(
        Camille::Types::Object.new(a: Camille::Types::Number),
        Camille::Types::Object.new(b: Camille::Types::String)
      )
    }

    let(:intersection_with_union){
      described_class.new(
        Camille::Types::Object.new(a: Camille::Types::Number),
        Camille::Types::Union.new(
          Camille::Types::String,
          Camille::Types::Boolean
        )
      )
    }

    it 'returns correct literal' do
      expect(intersection.literal).to eq('(number & string)')
    end

    xit 'returns correct literal when mixed with union' do
      expect(intersection_with_union.literal).to eq('(number & (string | boolean))')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on content regardless of order' do
      intersection_a = described_class.new(
        Camille::Types::Object.new({ a: Camille::Types::Number }),
        Camille::Types::Object.new({ b: Camille::Types::String })
      )

      intersection_a1 = described_class.new(
        Camille::Types::Object.new({ b: Camille::Types::String }),
        Camille::Types::Object.new({ a: Camille::Types::Number })
      )

      intersection_b = described_class.new(
        Camille::Types::Object.new({ a: Camille::Types::Number }),
        Camille::Types::Object.new({ c: Camille::Types::String })
      )

      expect(intersection_a.fingerprint).to eq(intersection_a1.fingerprint)
      expect(intersection_a.fingerprint).not_to eq(intersection_b.fingerprint)
    end
  end
end
