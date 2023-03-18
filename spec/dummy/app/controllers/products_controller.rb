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

  def date_and_decimal
    render json: {
      date: Date.new(1999, 12, 31),
      decimal: BigDecimal('1.2')
    }
  end

  def nested_date_and_decimal
    render json: {
      nested: {
        date: Date.new(1999, 12, 31),
        decimal: BigDecimal('1.2')
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