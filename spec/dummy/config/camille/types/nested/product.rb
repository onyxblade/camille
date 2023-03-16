using Camille::Syntax

class Camille::Types::Nested::Product < Camille::Type
  include Camille::Types

  alias_of(
    id: Number,
    name: String
  )
end