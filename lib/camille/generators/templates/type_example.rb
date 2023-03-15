using Camille::CoreExt

class Camille::Types::Example < Camille::Type
  include Camille::Types

  alias_of(
    id: Number,
    name: String,
  )
end