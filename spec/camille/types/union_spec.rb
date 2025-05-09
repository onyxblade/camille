
RSpec.describe Camille::Types::Union do
  describe '#initialize' do
    it "accepts two types" do
      union = Camille::Types::Union.new(Camille::Types::Number, Camille::Types::String)
      expect(union).to be_an_instance_of(Camille::Types::Union)
    end
  end

  describe '#check' do
    let(:union_type){
      described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )
    }
    let(:union_type_with_date) {
      described_class.new(
        Camille::Types::Number,
        Camille::Types::DateTime
      )
    }

    it 'checks if value is acceptable type' do
      result = union_type.check(1)
      expect(result).to have_checked_value(1)

      result = union_type.check('2')
      expect(result).to have_checked_value('2')
    end

    it 'returns composite error if value is not acceptable type' do
      error = union_type.check(true)

      expect(error).to be_composite_type_error
      expect(error.components.keys.first).to eq('union.left')
      expect(error.components.values.first).to be_basic_type_error
      expect(error.components.values.first.message).to eq("Expected an integer or a float, got true.")
      expect(error.components.keys.last).to eq('union.right')
      expect(error.components.values.last).to be_basic_type_error
      expect(error.components.values.last.message).to eq("Expected string, got true.")
    end

    it 'returns transformed value for date' do
      time = Time.now

      result = union_type_with_date.check(1)
      expect(result).to have_checked_value(1)

      result = union_type_with_date.check(time)
      expect(result).to have_checked_value(time.as_json)
    end

    it 'returns transformed value if it is on left' do
      time = Time.now
      type = Camille::Types::DateTime | Camille::Types::Number
      result = type.check(time)
      expect(result).to have_checked_value(time.as_json)
    end

    it 'returns nested transformed values' do
      type = Camille::Types::Number | (Camille::Types::String | Camille::Types::DateTime)
      time = Time.now
      result = type.check(time)
      expect(result).to have_checked_value(time.as_json)
    end
  end

  describe '#literal' do
    let(:union){
      described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )
    }

    it 'returns correct literal' do
      expect(union.literal).to eq('(number | string)')
    end

    it 'returns correct literal for union array' do
      expect(union[].literal).to eq('(number | string)[]')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on content regardless of order' do
      union_a = described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )

      union_a1 = described_class.new(
        Camille::Types::String,
        Camille::Types::Number
      )

      union_b = described_class.new(
        Camille::Types::Number,
        Camille::Types::Boolean
      )

      expect(union_a.fingerprint).to eq(union_a1.fingerprint)
      expect(union_a.fingerprint).not_to eq(union_b.fingerprint)
    end
  end
end
