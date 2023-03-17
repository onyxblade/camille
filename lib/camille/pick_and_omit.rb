module Camille
  # shared base class for Pick and Omit
  class PickAndOmit < Camille::BasicType
    class ArgumentError < ::ArgumentError; end

    def initialize type, keys
      @type = Camille::Type.instance(type)
      case
      when @type.is_a?(Camille::Types::Object)
        @target_object = @type
      when @type.is_a?(Camille::Type) && @type.underlying.is_a?(Camille::Types::Object)
        @target_object = @type.underlying
      else
        raise ArgumentError.new("Currently onle an object type or an alias of object type is supported in #{klass_name}. Got #{type.inspect}.")
      end

      @keys = Camille::Type.instance(keys)
      case
      when @keys.is_a?(Camille::Types::StringLiteral)
        @keys_array = [@keys.value].map(&:to_sym)
      when @keys.is_a?(Camille::Types::Union)
        unfolded = unfold_union(@keys).flatten
        if unfolded.all?{|x| x.is_a?(Camille::Types::StringLiteral)}
          @keys_array = unfolded.map(&:value).map(&:to_sym)
        else
          raise ArgumentError.new("The second argument of #{klass_name} has to be a string literal or an union of string literals. Got #{keys.inspect}.")
        end
      else
        raise ArgumentError.new("The second argument of #{klass_name} has to be a string literal or an union of string literals. Got #{keys.inspect}.")
      end
    end

    def literal
      "#{klass_name}<#{@type.literal}, #{@keys.literal}>"
    end

    def self.[] type, keys
      self.new type, keys
    end

    private
      def unfold_union type
        if type.is_a?(Camille::Types::Union)
          [unfold_union(type.left), unfold_union(type.right)]
        else
          [type]
        end
      end

  end
end