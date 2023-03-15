require 'action_controller'

module Camille
  class MainController < ActionController::Base
    def endpoints_ts
      render plain: Camille::CodeGenerator.generate_ts
    end
  end
end