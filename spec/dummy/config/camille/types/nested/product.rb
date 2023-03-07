using Camille::CoreExt

class Camille::Types::Nested::Product < Camille::Type
  alias_of(
    id: Number,
    name: String
  )
end