module Camille
  module Controller
    class TypeError < ::StandardError; end
    class ParamsTypeError < TypeError; end
    class ResponseTypeError < TypeError; end
    class ArgumentError < ::ArgumentError; end
    class MissingRenderError < ::StandardError; end

    def camille_schema
      @camille_schema ||= Camille::Loader.controller_name_to_schema_map[self.class.name]
    end

    def camille_endpoint
      camille_schema && camille_schema.endpoints[action_name.to_sym]
    end

    def render *args
      if endpoint = camille_endpoint
        render_options = args.last
        intended_status = render_options[:status] || 200
        if intended_status == 200 || intended_status == :ok
          if render_options.has_key? :json
            value = render_options[:json]
            result = endpoint.response_type.check(value)
            if result.type_error?
              string_io = StringIO.new
              Camille::TypeErrorPrinter.new(result).print(string_io)
              raise ResponseTypeError.new("\nType check failed for response.\n#{string_io.string}")
            else
              rendered = result.render.json
              super(json: rendered)
            end
          else
            raise ArgumentError.new("Expected key :json for `render` call.")
          end
        else
          super
        end
      else
        super
      end
    end

    def process_action(*)
      Camille::Loader.check_and_raise_exception
      if endpoint = camille_endpoint
        begin
          if Camille::Configuration.check_params
            # New way: check params against the endpoint's params_type if it exists
            if endpoint.params_type
              params_to_check = params.to_unsafe_h
              check_result = endpoint.params_type.check_params(params_to_check)

              if check_result.type_error?
                string_io = StringIO.new
                Camille::TypeErrorPrinter.new(check_result).print(string_io)
                raise ParamsTypeError.new("\nType check failed for params.\n#{string_io.string}")
              else
                # Use the checked value which already has snake_case keys
                self.params = ActionController::Parameters.new(check_result.value)
              end
            end
          else
            # Old way: just transform keys
            params.deep_transform_keys!{|key| Camille::Configuration.params_key_converter.call(key.to_s)}
          end

          result = super
          # When there's no `render` call, Rails will return status 204
          if response.status == 204
            raise_missing_render_error
          end
          result
        rescue ActionController::MissingExactTemplate
          raise_missing_render_error
        end
      else
        super
      end
    end

    private
      def raise_missing_render_error
        raise MissingRenderError.new("Expected `render json:` call in controller action body.")
      end

  end
end