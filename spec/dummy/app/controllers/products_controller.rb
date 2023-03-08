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
end