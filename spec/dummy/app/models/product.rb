class Product
  def self.fields
    {
      id: Camille::Types::Number,
      name: Camille::Types::String,
      available_stock: Camille::Types::Number
    }
  end
end