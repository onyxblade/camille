module Camille
  module Controller
    class TypeError < ::StandardError; end
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
        if value = render_options[:json]
          error, transformed = endpoint.response_type.transform_and_check(value)
          if error
            string_io = StringIO.new
            Camille::TypeErrorPrinter.new(error).print(string_io)
            raise TypeError.new("\nType check failed for response.\n#{string_io.string}")
          else
            if transformed.is_a? Hash
              transformed.deep_transform_keys!{|k| k.to_s.camelize(:lower)}
            end
            @camille_rendered = true
            super(json: transformed)
          end
        else
          raise ArgumentError.new("Expected key :json for `render` call.")
        end
      else
        super
      end
    end

    def process_action(*)
      Camille::Loader.check_and_raise_exception
      if endpoint = camille_endpoint
        begin
          params.deep_transform_keys!{|key| key.to_s.underscore}
          result = super
          unless @camille_rendered
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