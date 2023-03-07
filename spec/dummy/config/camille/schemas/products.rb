using Camille::CoreExt

class Camille::Schemas::Products < Camille::Schema
  get :data do
    params(
      id: Number
    )
    response(
      product: Product
    )
  end
end