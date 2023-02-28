
RSpec.describe Camille::Type do
  describe "#|" do
    it 'generates an union type' do
      union = Camille::Types::Number.new | Camille::Types::String.new
      expect(union.left).to be_an_instance_of(Camille::Types::Number)
      expect(union.right).to be_an_instance_of(Camille::Types::String)
    end
  end
end
