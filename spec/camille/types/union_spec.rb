
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

    it 'checks if value is acceptable type' do
      expect(union_type.check(1)).to be nil
      expect(union_type.check('1')).to be nil
    end

    it 'returns composite error if value is not acceptable type' do
      error = union_type.check(true)

      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('union.left')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be true
      expect(error.components.keys.last).to eq('union.right')
      expect(error.components.values.last).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.last.basic?).to be true
    end
  end
end
