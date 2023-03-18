module Camille
  module Types
    class Pick < PickAndOmit
      def check value
        processed_object.check(value)
      end

      def check_and_transform value
        processed_object.check_and_transform(value)
      end

      private
        def klass_name
          'Pick'
        end

        def processed_object
          fields = @target_object.fields.select{|k, _| @keys_array.include?(k)}
          Camille::Types::Object.new(fields)
        end

    end
  end
end