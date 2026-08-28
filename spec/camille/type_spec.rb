
RSpec.describe Camille::Type do
  before(:all) do
    class Camille::Types::TypeSpec < Camille::Type
      include Camille::Types

      alias_of(Number)
    end

    class Camille::Types::TypeSpec::Nested < Camille::Type
      include Camille::Types

      alias_of(
        id: Number,
        name: String
      )
    end

    class Camille::Types::TypeSpec::Empty < Camille::Type
      include Camille::Types

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

  describe '.render!' do
    it 'returns Rendered for a valid value' do
      rendered = Camille::Types::TypeSpec::Nested.render!(id: 1, name: 'a')
      expect(rendered).to be_an_instance_of(Camille::Rendered)
      expect(rendered.fingerprint).to eq(Camille::Types::TypeSpec::Nested.new.fingerprint)
      expect(rendered.json).to eq('{"id":1,"name":"a"}')
    end

    it 'is accepted by the same type without re-checking' do
      rendered = Camille::Types::TypeSpec::Nested.render!(id: 1, name: 'a')
      result = Camille::Types::TypeSpec::Nested.check(rendered)
      expect(result).to be_an_instance_of(Camille::Checked)
      expect(result.render).to be rendered
    end

    it 'raises RenderError with the printed type error for an invalid value' do
      expect {
        Camille::Types::TypeSpec::Nested.render!(id: 1, name: 2)
      }.to raise_error(Camille::BasicType::RenderError, /name: Expected string, got 2\./)
    end
  end

  describe '.alias_of' do
    it 'defines type alias' do
      expect(Camille::Types::TypeSpec.new.underlying).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#check' do
    it 'uses the underlying type to check' do
      expect(Camille::Types::TypeSpec.new.check(1)).to be_checked
      expect(Camille::Types::TypeSpec.new.check('1')).to be_basic_type_error
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
        Camille::Types::TypeSpec::Empty,
        Camille::Types::DateTime,
        Camille::Types::Decimal
      )
    end
  end

  describe '#check' do
    it 'typechecks the value' do
      expect(Camille::Types::TypeSpec.new.check(1)).to be_checked
      expect(Camille::Types::TypeSpec.new.check('1')).to be_basic_type_error
    end
  end

  describe '.check' do
    it 'typechecks the value' do
      expect(Camille::Types::TypeSpec.check(1)).to be_checked
      expect(Camille::Types::TypeSpec.check('1')).to be_basic_type_error
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint of underlying type' do
      expect(Camille::Types::TypeSpec.new.fingerprint).to eq(Camille::Types::Number.new.fingerprint)
    end
  end

end
