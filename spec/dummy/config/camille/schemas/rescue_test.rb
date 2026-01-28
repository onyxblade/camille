using Camille::Syntax

class Camille::Schemas::RescueTest < Camille::Schema
  include Camille::Types

  post :update do
    params(
      id: Number
    )
    response(Any)
  end

  get :wrong_response do
    response(
      id: Number
    )
  end
end
