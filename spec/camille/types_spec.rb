
RSpec.describe Camille::Types do
  before(:all) do
    class Camille::Types::Product < Camille::Type
      alias_of(
        id: Number,
        name: String
      )
    end

    class Camille::Types::DateTime < Camille::Type
      alias_of(String)
    end

    class Camille::Types::Product::Details < Camille::Type
      alias_of(
        price: Number
      )
    end
  end

  after(:all) do
    Camille::Types.loaded_types.delete(Camille::Types::Product)
    Camille::Types.loaded_types.delete(Camille::Types::DateTime)
    Camille::Types.loaded_types.delete(Camille::Types::Product::Details)
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
