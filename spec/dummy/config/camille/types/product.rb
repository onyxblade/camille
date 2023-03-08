using Camille::CoreExt

class Camille::Types::Product < Camille::Type
  alias_of(
    id: Number,
    name: String,
    available_stock: Number
  )
end