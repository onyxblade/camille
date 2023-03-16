using Camille::Syntax

class Camille::Schemas::Products < Camille::Schema
  include Camille::Types

  get :data do
    params(
      id: Number
    )
    response(
      product: Product
    )
  end

  get :wrong_data do
    response(
      product: Product
    )
  end

  post :update do
    params(
      id: Number,
      product: {
        name: String,
        available_stock: Number
      }
    )
    response(Any)
  end
end