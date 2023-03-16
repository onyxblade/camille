using Camille::Syntax

class Camille::Schemas::Nested::Products < Camille::Schema
  include Camille::Types

  get :data do
    params(
      id: Number
    )
    response(
      product: Product
    )
  end
end