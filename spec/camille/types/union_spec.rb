
RSpec.describe Camille::Types::Union do
  describe '#initialize' do
    it "accepts two types" do
      union = Camille::Types::Union.new(Camille::Types::Number, Camille::Types::String)
      expect(union).to be_an_instance_of(Camille::Types::Union)
    end
  end

  describe '#transform_and_check' do
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
      error, transformed = union_type.transform_and_check(1)
      expect(error).to be nil
      expect(transformed).to eq(1)

      error, transformed = union_type.transform_and_check('2')
      expect(error).to be nil
      expect(transformed).to eq('2')
    end

    it 'returns composite error if value is not acceptable type' do
      error, transformed = union_type.transform_and_check(true)

      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('union.left')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be true
      expect(error.components.keys.last).to eq('union.right')
      expect(error.components.values.last).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.last.basic?).to be true
    end

    it 'returns transformed value for date' do
      time = Time.now

      _, transformed = union_type_with_date.transform_and_check(1)
      expect(transformed).to eq(1)

      _, transformed = union_type_with_date.transform_and_check(time)
      expect(transformed).to eq(time.as_json)
    end

    it 'returns transformed value if it is on left' do
      time = Time.now
      type = Camille::Types::DateTime | Camille::Types::Number
      error, transformed = type.transform_and_check(time)
      expect(error).to be nil
      expect(transformed).to eq(time.as_json)
    end

    it 'returns nested transformed values' do
      type = Camille::Types::Number | (Camille::Types::String | Camille::Types::DateTime)
      time = Time.now
      error, transformed = type.transform_and_check(time)
      expect(error).to be nil
      expect(transformed).to eq(time.as_json)
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      union = described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )
      expect(union.literal).to eq('number | string')
    end
  end
end
