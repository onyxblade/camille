using Camille::CoreExt

module Camille::Types
  class Example < Camille::Type
    alias_of(
      id: Number,
      name: String,
    )
  end
end