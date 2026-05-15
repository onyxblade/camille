require 'action_dispatch'

module Camille
  module RSpec
    class ResponseTypeError < ::StandardError; end
    class MissingEndpointError < ::StandardError; end

    module ResponseExtension
      def data
        unless request
          raise Camille::RSpec::MissingEndpointError,
            "No request associated with this response."
        end

        controller_class_name = "#{request.path_parameters[:controller].camelize}Controller"
        schema   = Camille::Loader.controller_name_to_schema_map[controller_class_name]
        endpoint = schema && schema.endpoints[request.path_parameters[:action].to_sym]

        unless endpoint
          raise Camille::RSpec::MissingEndpointError,
            "No camille endpoint for #{controller_class_name}##{request.path_parameters[:action]}."
        end

        result = endpoint.response_type.check_params(parsed_body)
        if result.type_error?
          io = StringIO.new
          Camille::TypeErrorPrinter.new(result).print(io)
          raise Camille::RSpec::ResponseTypeError,
            "\nResponse type check failed.\n#{io.string}"
        end

        deep_indifferent(result.value)
      end

      private

      def deep_indifferent value
        case value
        when Hash  then value.with_indifferent_access
        when Array then value.map { |v| deep_indifferent(v) }
        else value
        end
      end
    end
  end
end

ActionDispatch::TestResponse.prepend(Camille::RSpec::ResponseExtension)
