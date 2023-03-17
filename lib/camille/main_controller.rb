require 'action_controller'

module Camille
  class MainController < ActionController::Base
    def endpoints_ts
      Camille::Loader.check_and_raise_exception
      render plain: Camille::CodeGenerator.generate_ts
    end
  end
end