using Camille::Syntax

RSpec.describe Camille::Types::Pick do
  before(:all) do
    class Camille::Types::ObjectAlias < Camille::Type
      include Camille::Types

      alias_of(
        a: Number,
        b: Number,
        c: Number
      )
    end
  end

  after(:all) do
    Camille::Loader.loaded_types.delete(Camille::Types::ObjectAlias)
    Camille::Types.send(:remove_const, :ObjectAlias)
  end

  describe '#initialize' do
    it 'raises unless receiving an object type or an alias of object type' do
      expect{Camille::Types::Pick.new({a: 1}, [:a])}.not_to raise_error
      expect{Camille::Types::Pick.new(Camille::Types::ObjectAlias, [:a])}.not_to raise_error
      expect{Camille::Types::Pick.new(Camille::Types::Number, [:a])}.to raise_error(Camille::Types::Pick::ArgumentError)
    end

    it 'raises unless receiving a string literal or a union of literals' do
      expect{Camille::Types::Pick.new({a: 1}, [:a])}.not_to raise_error
      expect{Camille::Types::Pick.new({a: 1}, [:a, :b])}.not_to raise_error
      expect{Camille::Types::Pick.new({a: 1}, [:a, :b, 1])}.to raise_error(Camille::Types::Pick::ArgumentError)
    end
  end

  describe '#check' do
    it 'checks the value with keys picked' do
      object = {
        a: Camille::Types::Number,
        b: Camille::Types::Number,
        c: Camille::Types::Number
      }

      result = Camille::Types::Pick.new(object, [:a]).check({a: 1})
      expect(result).to have_checked_value({a: 1})

      result = Camille::Types::Pick.new(object, [:a, :b]).check({a: 1, b: 2})
      expect(result).to have_checked_value({a: 1, b: 2})

      expect(Camille::Types::Pick.new(object, [:a, :b, :c]).check({a: 1, b: 2})).to be_composite_type_error

      result = Camille::Types::Pick.new(Camille::Types::ObjectAlias, [:a]).check({a: 1})
      expect(result).to have_checked_value({a: 1})

      result = Camille::Types::Pick.new(Camille::Types::ObjectAlias, [:a, :b]).check({a: 1, b: 2})
      expect(result).to have_checked_value({a: 1, b: 2})

      expect(Camille::Types::Pick.new(Camille::Types::ObjectAlias, [:a, :b, :c]).check({a: 1, b: 2})).to be_composite_type_error
    end

    it 'returns the transformed value' do
      object = {
        a: Camille::Types::Number,
        b: Camille::Types::Number,
        c: Camille::Types::Number
      }

      result = Camille::Types::Pick.new(object, [:a]).check({a: 1})
      expect(result).to have_checked_value({a: 1})
    end

    it 'handles keys of snake case' do
      object = {
        long_name: Camille::Types::Number
      }
      type = Camille::Types::Pick.new(object, [:long_name])

      error = type.check({})
      expect(error).to be_composite_type_error

      result = type.check({long_name: 1})
      expect(result).to be_checked
    end

    it 'preserves optional fields' do
      object = {
        id: Camille::Types::Number,
        name?: Camille::Types::String,
        price: Camille::Types::Number
      }
      type = Camille::Types::Pick.new(object, [:id, :name])
      result = type.check({id: 1})
      expect(result).to be_checked
    end
  end

  describe '#literal' do
    it 'returns literal for objects' do
      expect(Camille::Types::Pick.new({a: 1}, [:a]).literal).to eq('Pick<{a: 1}, "a">')
      expect(Camille::Types::Pick.new({a: 1}, [:a, :b]).literal).to eq('Pick<{a: 1}, "a" | "b">')
      expect(Camille::Types::Pick.new({a: 1}, [:a, :b, :c]).literal).to eq('Pick<{a: 1}, "a" | "b" | "c">')
    end

    it 'returns liter for object aliases' do
      expect(Camille::Types::Pick.new(Camille::Types::ObjectAlias, [:a, :b]).literal).to eq('Pick<ObjectAlias, "a" | "b">')
    end

    it 'handles keys of snake case' do
      object = {
        long_name: Camille::Types::Number
      }
      type = Camille::Types::Pick.new(object, [:long_name])

      expect(type.literal).to eq('Pick<{longName: number}, "longName">')
    end
  end

  describe '.[]' do
    it 'instantiates a pick type' do
      expect(Camille::Types::Pick[{a: 1}, [:a]]).to be_instance_of(Camille::Types::Pick)
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on content' do
      pick_a = described_class.new(
        {a: 1, b: 2, c: 3},
        [:a, :b]
      )

      pick_a1 = described_class.new(
        {a: 1, b: 2, c: 3},
        [:b, :a]
      )

      pick_b = described_class.new(
        {a: 1, b: 2, c: 3},
        [:a]
      )

      expect(pick_a.fingerprint).to eq(pick_a1.fingerprint)
      expect(pick_a.fingerprint).not_to eq(pick_b.fingerprint)
    end

    it 'returns different fingerprint from omit' do
      pick = Camille::Types::Pick.new(
        {a: 1, b: 2, c: 3},
        [:a, :b]
      )

      omit = Camille::Types::Omit.new(
        {a: 1, b: 2, c: 3},
        [:a, :b]
      )

      expect(pick.fingerprint).not_to eq(omit.fingerprint)
    end
  end

end
