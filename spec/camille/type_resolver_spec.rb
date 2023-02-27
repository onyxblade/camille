
RSpec.describe Camille::TypeResolver do
  let(:type_store) {
    store = Camille::TypeStore.new
    store.add(:number, Camille::Types::Number)
    store.add(:array, Camille::Types::Array)
    store
  }

  describe "#eval" do
    it 'resolves types by names' do
      resolver = Camille::TypeResolver.new(type_store)
      expect(resolver.eval{ number }).to be_an_instance_of(Camille::Types::Number)
      expect(resolver.eval{ array(number) }).to be_an_instance_of(Camille::Types::Array)
    end
  end
end
