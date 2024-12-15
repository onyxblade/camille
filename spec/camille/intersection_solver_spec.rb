
RSpec.describe Camille::IntersectionSolver do
  describe '.solve' do
    shared_examples 'generating the expected object' do
      it 'generates the expected object' do
        actual = described_class.solve(type_a, type_b)
        expect(actual.fingerprint).to eq(expected.fingerprint)
      end
    end

    context 'for simple types' do
      let(:type_a) { Camille::Types::Number.new }
      let(:type_b) { Camille::Types::Number.new }
      let(:expected) { Camille::Types::Number.new }

      it_behaves_like 'generating the expected object'
    end

    context 'for simple objects' do
      context 'for different types in both sides' do
        let(:type_a) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ b: Camille::Types::String }) }
        let(:expected) {
          Camille::Types::Object.new({
            a: Camille::Types::Number,
            b: Camille::Types::String
          })
        }

        it_behaves_like 'generating the expected object'
      end

      context 'for same types in both sides' do
        let(:type_a) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:expected) {
          Camille::Types::Object.new({
            a: Camille::Types::Number
          })
        }

        it_behaves_like 'generating the expected object'
      end
    end

    context 'for optional fields' do
      context 'for optional fields appearing in one side' do
        let(:type_a) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ b: Camille::Types::String }) }
        let(:expected) {
          Camille::Types::Object.new({
            a?: Camille::Types::Number,
            b: Camille::Types::String
          })
        }

        it_behaves_like 'generating the expected object'
      end

      context 'for optional fields appearing in both sides and only one optional' do
        let(:type_a) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:expected) {
          Camille::Types::Object.new({
            a: Camille::Types::Number
          })
        }

        it_behaves_like 'generating the expected object'
      end

      context 'for optional fields appearing in both sides and both optional' do
        let(:type_a) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:expected) {
          Camille::Types::Object.new({
            a?: Camille::Types::Number
          })
        }

        it_behaves_like 'generating the expected object'
      end
    end

    context 'for nested objects' do
      context 'for different types in both side' do
        let(:type_a) { Camille::Types::Object.new({ o: {a: Camille::Types::Number }}) }
        let(:type_b) { Camille::Types::Object.new({ o: {b: Camille::Types::String }}) }
        let(:expected) {
          Camille::Types::Object.new({
            o: {
              a: Camille::Types::Number,
              b: Camille::Types::String
            }
          })
        }

        it_behaves_like 'generating the expected object'
      end

      context 'for same types in both side' do
        let(:type_a) { Camille::Types::Object.new({ o: {a: Camille::Types::Number }}) }
        let(:type_b) { Camille::Types::Object.new({ o: {a: Camille::Types::Number }}) }
        let(:expected) {
          Camille::Types::Object.new({
            o: {
              a: Camille::Types::Number
            }
          })
        }

        it_behaves_like 'generating the expected object'
      end
    end

    context 'for incompatible types' do
      shared_examples 'raising an error' do
        it 'raises an error' do
          expect{described_class.solve(type_a, type_b)}.to raise_error(described_class::TypeNotCompatibleError)
        end
      end

      context 'for simple types' do
        let(:type_a) { Camille::Types::Number.new }
        let(:type_b) { Camille::Types::NumberLiteral.new(1) }

        it_behaves_like 'raising an error'
      end

      context 'for non-object and object' do
        let(:type_a) { Camille::Types::Number.new }
        let(:type_b) { Camille::Types::Object.new({ a: 1 }) }

        it_behaves_like 'raising an error'
      end

    end

  end
end