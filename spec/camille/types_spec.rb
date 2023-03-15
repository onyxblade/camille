
RSpec.describe Camille::Types do
  before(:all) do
    class Camille::Types::Product < Camille::Type
      include Camille::Types

      alias_of(
        id: Number,
        name: String
      )
    end

    class Camille::Types::DateTime < Camille::Type
      include Camille::Types

      alias_of(String)
    end

    class Camille::Types::Product::Details < Camille::Type
      include Camille::Types

      alias_of(
        price: Number
      )
    end
  end

  after(:all) do
    Camille::Loader.loaded_types.delete(Camille::Types::Product)
    Camille::Loader.loaded_types.delete(Camille::Types::DateTime)
    Camille::Loader.loaded_types.delete(Camille::Types::Product::Details)
    Camille::Types.send(:remove_const, :Product)
    Camille::Types.send(:remove_const, :DateTime)
  end

  describe '.literal_lines' do
    it 'returns the correct literal' do
      text = <<~EOF.chomp
      type DateTime = string
      type Product = {id: number, name: string}
      type Product_Details = {price: number}
      EOF

      expect(Camille::Types.literal_lines.join("\n")).to eq(text)
    end
  end
end
