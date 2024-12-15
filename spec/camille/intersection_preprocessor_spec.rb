
RSpec.describe Camille::IntersectionPreprocessor do
  describe '.process' do
    shared_examples 'generating the expected object' do
      it 'generates the expected object' do
        left, right = described_class.process(type_a, type_b)
        expect(left.fingerprint).to eq(expected_left.fingerprint)
        expect(right.fingerprint).to eq(expected_right.fingerprint)
      end
    end

    context 'for simple types' do
      let(:type_a) { Camille::Types::Number.new }
      let(:type_b) { Camille::Types::Number.new }
      let(:expected_left) { Camille::Types::Number.new }
      let(:expected_right) { Camille::Types::Any.new }

      it_behaves_like 'generating the expected object'
    end

    context 'for simple objects' do
      context 'for different types in both sides' do
        let(:type_a) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ b: Camille::Types::String }) }
        let(:expected_left) { type_a }
        let(:expected_right) { type_b }

        it_behaves_like 'generating the expected object'
      end

      context 'for same types in both sides' do
        let(:type_a) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:expected_left) {
          Camille::Types::Object.new({
            a: Camille::Types::Number
          })
        }
        let(:expected_right) {
          Camille::Types::Object.new({
            a: Camille::Types::Any
          })
        }

        it_behaves_like 'generating the expected object'
      end
    end

    context 'for optional fields' do
      context 'for optional fields appearing in one side' do
        let(:type_a) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ b: Camille::Types::String }) }
        let(:expected_left) { type_a }
        let(:expected_right) { type_b }

        it_behaves_like 'generating the expected object'
      end

      context 'for optional fields appearing in both sides and only one optional' do
        let(:type_a) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ a: Camille::Types::Number }) }
        let(:expected_left) {
          Camille::Types::Object.new({
            a: Camille::Types::Number
          })
        }
        let(:expected_right) {
          Camille::Types::Object.new({
            a: Camille::Types::Any
          })
        }

        it_behaves_like 'generating the expected object'
      end

      context 'for optional fields appearing in both sides and both optional' do
        let(:type_a) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:type_b) { Camille::Types::Object.new({ a?: Camille::Types::Number }) }
        let(:expected_left) {
          Camille::Types::Object.new({
            a?: Camille::Types::Number
          })
        }
        let(:expected_right) {
          Camille::Types::Object.new({
            a?: Camille::Types::Any
          })
        }

        it_behaves_like 'generating the expected object'
      end
    end

    context 'for nested objects' do
      context 'for different types in both side' do
        let(:type_a) { Camille::Types::Object.new({ o: {a: Camille::Types::Number }}) }
        let(:type_b) { Camille::Types::Object.new({ o: {b: Camille::Types::String }}) }
        let(:expected_left) { type_a }
        let(:expected_right) { type_b }

        it_behaves_like 'generating the expected object'
      end

      context 'for same types in both side' do
        let(:type_a) { Camille::Types::Object.new({ o: {a: Camille::Types::Number }}) }
        let(:type_b) { Camille::Types::Object.new({ o: {a: Camille::Types::Number }}) }
        let(:expected_left) {
          Camille::Types::Object.new({
            o: {
              a: Camille::Types::Number
            }
          })
        }
        let(:expected_right) {
          Camille::Types::Object.new({
            o: {
              a: Camille::Types::Any
            }
          })
        }

        it_behaves_like 'generating the expected object'
      end
    end

    context 'for incompatible types' do
      shared_examples 'raising an error' do
        it 'raises an error' do
          expect{described_class.process(type_a, type_b)}.to raise_error(described_class::TypeNotCompatibleError)
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