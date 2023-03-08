class ProductsController < ApplicationController
  def data
    render json: {
      product: {
        id: 1,
        name: 's',
        available_stock: 1
      }
    }
  end

  def wrong_data
    render json: {
      product: {
        id: 1,
        name: 's',
        available_stock: '1'
      }
    }
  end

  def update
    render json: params.to_unsafe_h.to_json
  end


  def non_camille_action
    render json: {
      underscore_param: params[:underscore_param]
    }
  end
end