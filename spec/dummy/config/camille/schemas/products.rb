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

  get :missing_render do
    response(Any)
  end

  get :head_401 do
    response(Any)
  end

  get :render_401 do
    response(id: Number)
  end

  get :response_false do
    response(Boolean)
  end

  get :string_records do
    response({
      string_records: Record[String, Number]
    })
  end
end