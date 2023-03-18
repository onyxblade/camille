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

  get :date_and_decimal do
    response(
      date: DateTime,
      decimal: Decimal
    )
  end

  get :nested_date_and_decimal do
    response(
      nested: {
        date: DateTime,
        decimal: Decimal
      }
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