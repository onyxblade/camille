using Camille::CoreExt

class Camille::Schemas::Examples < Camille::Schema
  include Camille::Types

  get :find do
    params(
      id: Number
    )

    response(
      example?: Example
    )
  end

  get :list do
    response(
      examples: Example[]
    )
  end

  post :update do
    params(
      id: Number,
      example: Example
    )

    response(
      success: Boolean,
      errors: {
        message: String
      }[]
    )
  end
end