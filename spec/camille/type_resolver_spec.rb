
RSpec.describe Camille::TypeResolver do
  let(:type_store) {
    store = Camille::TypeStore.new
    store.add(:number, Camille::Types::Number)
    store.add(:string, Camille::Types::String)
    store.add(:array, Camille::Types::Array)
    store
  }
  let(:resolver) { Camille::TypeResolver.new(type_store) }

  describe "#eval" do
    it 'resolves types by names' do
      expect(resolver.eval{ number }).to be_an_instance_of(Camille::Types::Number)
      expect(resolver.eval{ array(number) }).to be_an_instance_of(Camille::Types::Array)
    end

    it 'resolves array type by `type[]`' do
      type = resolver.eval{ number[] }
      expect(type).to be_an_instance_of(Camille::Types::Array)
      expect(type.content).to be_an_instance_of(Camille::Types::Number)
    end

    it 'resolves union type by |' do
      type = resolver.eval{ number | string }
      expect(type).to be_an_instance_of(Camille::Types::Union)
      expect(type.left).to be_an_instance_of(Camille::Types::Number)
      expect(type.right).to be_an_instance_of(Camille::Types::String)
    end

    it 'raises when no type found' do
      expect{resolver.eval{ integer }}.to raise_error(Camille::TypeResolver::NoMethodError)
    end
  end
end
