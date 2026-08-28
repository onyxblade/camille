require 'action_dispatch'

module Camille
  module Testing
    class ResponseTypeError < ::StandardError; end
    class MissingEndpointError < ::StandardError; end

    module ResponseExtension
      def data
        controller_path = request && request.path_parameters[:controller]
        action          = request && request.path_parameters[:action]

        unless controller_path && action
          raise Camille::Testing::MissingEndpointError,
            "No camille endpoint for this response (request did not match a controller action)."
        end

        controller_class_name = "#{controller_path.camelize}Controller"
        schema   = Camille::Loader.controller_name_to_schema_map[controller_class_name]
        endpoint = schema && schema.endpoints[action.to_sym]

        unless endpoint
          raise Camille::Testing::MissingEndpointError,
            "No camille endpoint for #{controller_class_name}##{action}."
        end

        # Camille::Controller#render only type checks and converts keys for
        # 200 responses, so mirror that here and return non-200 bodies as-is.
        return deep_indifferent(parsed_body) unless status == 200

        result = endpoint.response_type.check_params(parsed_body)
        if result.type_error?
          io = StringIO.new
          Camille::TypeErrorPrinter.new(result).print(io)
          raise Camille::Testing::ResponseTypeError,
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

ActionDispatch::TestResponse.prepend(Camille::Testing::ResponseExtension)
