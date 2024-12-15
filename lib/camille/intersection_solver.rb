module Camille
  class IntersectionSolver
    class TypeNotCompatibleError < ArgumentError; end

    class << self
      def solve a, b
        if a.instance_of?(Camille::Types::Object) && b.instance_of?(Camille::Types::Object)
          overlapping_keys = a.fields.keys & b.fields.keys

          new_fields = []
          new_optional_keys = []

          [a, b].each do |x|
            (x.fields.keys - overlapping_keys).each do |key|
              new_fields << [key, x.fields[key]]
              new_optional_keys << key if x.optional_keys.include?(key)
            end
          end

          overlapping_keys.map do |key|
            solved = IntersectionSolver.solve(a.fields[key], b.fields[key])
            new_fields << [key, solved]
            if a.optional_keys.include?(key) && b.optional_keys.include?(key)
              new_optional_keys << key
            end
          end

          Camille::Types::Object.new(**(apply_optional_to_fields new_fields, new_optional_keys).to_h)
        else
          if a.literal == b.literal
            a
          else
            raise TypeNotCompatibleError.new "Cannot reconcile type #{a.literal} and type #{b.literal}."
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