module Camille
  module Types
    class Omit < PickAndOmit

      private
        def klass_name
          'Omit'
        end

        def processed_object
          fields = @target_object.fields.reject{|k, _| @keys.include?(k)}
          fields.transform_keys! do |k,_|
            if @target_object.optional_keys.include?(k)
              "#{k}?".to_sym
            else
              k
            end
          end
          Camille::Types::Object.new(fields)
        end

    end
  end
end