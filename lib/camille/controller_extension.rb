module Camille
  module ControllerExtension
    class TypeError < ::StandardError; end
    class ArgumentError < ::ArgumentError; end

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
          error = endpoint.response_type.check(value)
          if error
            string_io = StringIO.new
            Camille::TypeErrorPrinter.new(error).print(string_io)
            raise TypeError.new("\nType check failed for response.\n#{string_io.string}")
          else
            if value.is_a? Hash
              value.deep_transform_keys!{|k| k.to_s.camelize(:lower)}
            end
            super(json: value)
          end
        else
          raise ArgumentError.new("Expected key :json for `render` call.")
        end
      else
        super
      end
    end

    def process_action(*)
      if endpoint = camille_endpoint
        params.deep_transform_keys!{|key| key.to_s.underscore}
        super
      else
        super
      end
    end

  end
end