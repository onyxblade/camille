
RSpec.describe Camille::TypeStore do
  describe "#add" do
    it "adds to the store" do
      type_store = Camille::TypeStore.new
      type_store.add :number, Camille::Types::Number
      expect(type_store.get :number).to be(Camille::Types::Number)
    end

    it "raises if type is not a subclass of Camille::Type" do
      type_store = Camille::TypeStore.new
      expect{type_store.add :number, Integer}.to raise_error(Camille::TypeStore::ArgumentError)
    end
  end
end
