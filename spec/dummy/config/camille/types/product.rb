using Camille::Syntax

class Camille::Types::Product < Camille::Type
  include Camille::Types

  alias_of(
    id: Number,
    name: String,
    available_stock: Number
  )
end