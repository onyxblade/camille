module Camille
  class IntersectionPreprocessor
    class TypeNotCompatibleError < ArgumentError; end

    class << self
      def process left, right
        if left.instance_of?(Camille::Types::Object) && right.instance_of?(Camille::Types::Object)
          overlapping_keys = left.fields.keys & right.fields.keys

          new_left_fields = []
          new_left_optional_keys = []
          new_right_fields = []
          new_right_optional_keys = []

          (left.fields.keys - overlapping_keys).each do |key|
            new_left_fields << [key, left.fields[key]]
            new_left_optional_keys << key if left.optional_keys.include?(key)
          end

          (right.fields.keys - overlapping_keys).each do |key|
            new_right_fields << [key, right.fields[key]]
            new_right_optional_keys << key if right.optional_keys.include?(key)
          end

          overlapping_keys.map do |key|
            processed_left, processed_right = IntersectionPreprocessor.process(left.fields[key], right.fields[key])
            new_left_fields << [key, processed_left]
            new_right_fields << [key, processed_right]

            if left.optional_keys.include?(key) && right.optional_keys.include?(key)
              new_left_optional_keys << key
              new_right_optional_keys << key
            end
          end

          [
            Camille::Types::Object.new(**(apply_optional_to_fields new_left_fields, new_left_optional_keys).to_h),
            Camille::Types::Object.new(**(apply_optional_to_fields new_right_fields, new_right_optional_keys).to_h)
          ]
        else
          if left.literal == right.literal
            [left, Camille::Types::Any.new]
          else
            raise TypeNotCompatibleError.new "Cannot reconcile type #{left.literal} and type #{right.literal}."
          end
        end
      end

      private
        def apply_optional_to_fields fields, optional_keys
          fields.map do |key, type|
            if optional_keys.include?(key)
              ["#{key.to_s}?".to_sym, type]
            else
              [key, type]
            end
          end
        end
    end
  end
end