module Camille
  class Endpoint
    attr_reader :params_type, :response_type, :verb

    def initialize verb
      @verb = verb
    end

    private
      def params type
        @params_type = Camille::Type.instance type
      end

      def response type
        @response_type = Camille::Type.instance type
      end
  end
end