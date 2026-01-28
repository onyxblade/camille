class RescueTestController < ApplicationController
  rescue_from Camille::Controller::ParamsTypeError do |e|
    render json: { error: 'params_type_error', message: e.message }, status: 400
  end

  rescue_from Camille::Controller::ResponseTypeError do |e|
    render json: { error: 'response_type_error', message: e.message }, status: 500
  end

  def update
    render json: params.to_unsafe_h
  end

  def wrong_response
    render json: { id: 'not_a_number' }
  end
end
