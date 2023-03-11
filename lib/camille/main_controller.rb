require 'action_controller'

module Camille
  class MainController < ActionController::Base
    def endpoints_ts
      if Rails.env.development?
        render plain: Camille::CodeGenerator.generate_ts
      else
        head 404
      end
    end
  end
end