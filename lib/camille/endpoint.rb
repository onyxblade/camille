module Camille
  class Endpoint
    class ArgumentError < ::ArgumentError; end
    class UnknownResponseError < ::ArgumentError; end

    attr_reader :params_type, :response_type, :verb, :name

    def initialize verb, name
      @verb = verb
      @name = name
    end

    def signature
      unless @response_type
        raise UnknownResponseError.new("Endpoint lacking a `response` definition.")
      end
      if @params_type
        "#{@name}(params: #{@params_type.literal}): Promise<#{@response_type.literal}>"
      else
        "#{@name}(): Promise<#{@response_type.literal}>"
      end
    end

    private
      def params type
        if type.is_a?(::Hash)
          @params_type = Camille::Type.instance type
        else
          raise ArgumentError.new("`params` requires a hash as input, got #{type.inspect}.")
        end
      end

      def response type
        @response_type = Camille::Type.instance type
      end
  end
end