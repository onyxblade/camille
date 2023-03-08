module Camille
  module ControllerExtension
    class TypeError < ::StandardError; end

    def camille_schema
      @camille_schema ||= Camille::Loader.controller_name_to_schema_map[self.class.name]
    end

    def camille_endpoint
      camille_schema && camille_schema.endpoints[action_name.to_sym]
    end

    def render *args
      if endpoint = camille_endpoint
        render_options = args.last
        if hash = render_options[:json]
          error = endpoint.response_type.check(hash)
          if error
            Camille::TypeErrorPrinter.new(error).print
            raise TypeError.new("Type check failed for response.")
          else
            hash.deep_transform_keys!{|k| k.to_s.camelize(:lower)}
            super(json: hash)
          end
        else
          raise "Expected a hash by `render json: hash`."
        end
      else
        super
      end
    end

  end
end