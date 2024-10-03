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

      unless keys.is_a?(::Array) && !keys.empty? && keys.all?{|x| x.is_a? Symbol}
        raise ArgumentError.new("The second argument of #{klass_name} has to be an array of symbols. Got #{keys.inspect}.")
      end
      @keys = keys
    end

    def literal
      "#{klass_name}<#{@type.literal}, #{keys_in_literal}>"
    end

    def self.[] type, keys
      self.new type, keys
    end

    private
      def keys_in_literal
        @keys.map{|k| "\"#{Camille::Configuration.response_key_converter.call(k)}\""}.join(' | ')
      end

  end
end