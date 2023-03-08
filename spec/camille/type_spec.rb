
RSpec.describe Camille::Type do
  before(:all) do
    class Camille::Types::TypeSpec < Camille::Type
      alias_of(Number)
    end

    class Camille::Types::TypeSpec::Nested < Camille::Type
      alias_of(
        id: Number,
        name: String
      )
    end

    class Camille::Types::TypeSpec::Empty < Camille::Type
      def self.unknown_constant
        UnknownConstant
      end
    end
  end

  after(:all) do
    Camille::Loader.loaded_types.delete(Camille::Types::TypeSpec)
    Camille::Loader.loaded_types.delete(Camille::Types::TypeSpec::Nested)
    Camille::Loader.loaded_types.delete(Camille::Types::TypeSpec::Empty)
    Camille::Types.send(:remove_const, :TypeSpec)
  end

  describe '.alias_of' do
    it 'defines type alias' do
      expect(Camille::Types::TypeSpec.new.underlying).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#check' do
    it 'uses the underlying type to check' do
      expect(Camille::Types::TypeSpec.new.check(1)).to be nil
      expect(Camille::Types::TypeSpec.new.check('1')).to be_an_instance_of(Camille::TypeError)
    end
  end

  describe '#directly_instantiable?' do
    it 'returns true' do
      expect(Camille::Types::TypeSpec.directly_instantiable?).to be true
    end
  end

  describe '#initialize' do
    it 'raises if no `alias_of` definition available' do
      expect{Camille::Types::TypeSpec::Empty.new}.to raise_error(Camille::Type::NotImplementedError)
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      expect(Camille::Types::TypeSpec.new.literal).to eq('TypeSpec')
      expect(Camille::Types::TypeSpec::Nested.new.literal).to eq('TypeSpec_Nested')
    end
  end

  describe '.inherited' do
    it 'add subclass to Loader.loaded_types' do
      expect(Camille::Loader.loaded_types).to contain_exactly(
        Camille::Types::TypeSpec,
        Camille::Types::TypeSpec::Nested,
        Camille::Types::TypeSpec::Empty
      )
    end
  end

  # The same goes for Camille::Schema
  describe '.const_missing' do
    context 'when Camille::Loader.eager_loading?' do
      it 'raises NameError under Camille::Types' do
        Camille::Loader.instance_eval{ @eager_loading = true }
        expect{Camille::Types::TypeSpec::Empty.unknown_constant}.to raise_error(NameError) {|error|
          expect(error.message).to eq('uninitialized constant Camille::Types::UnknownConstant')
        }
        Camille::Loader.instance_eval{ @eager_loading = false }
      end
    end

    context 'when after eager loading' do
      it 'raises NameError' do
        expect{Camille::Types::TypeSpec::Empty.unknown_constant}.to raise_error(NameError) {|error|
          expect(error.message).to eq('uninitialized constant Camille::Types::TypeSpec::Empty::UnknownConstant')
        }
      end
    end
  end
end
