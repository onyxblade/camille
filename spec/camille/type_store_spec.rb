
RSpec.describe Camille::TypeStore do
  let(:type_store) { Camille::TypeStore.new }

  describe "#add" do
    it "adds to the store" do
      type_store.add :number, Camille::Types::Number
      expect(type_store.get :number).to be(Camille::Types::Number)
    end

    it "raises if type is not a subclass of Camille::Type" do
      expect{type_store.add :number, Integer}.to raise_error(Camille::TypeStore::ArgumentError)
    end

    it "raises if unable to find type in store" do
      expect{type_store.get :number}.to raise_error(Camille::TypeStore::NoTypeError)
    end
  end
end
