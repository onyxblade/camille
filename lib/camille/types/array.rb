module Camille
  module Types
    class Array < Camille::BasicType
      attr_reader :content

      def initialize content
        @content = Camille::Type.instance content
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@content.fingerprint}"
      end

      def check value
        check_with_method(value, :check)
      end

      def check_params value
        check_with_method(value, :check_params)
      end

      def literal
        "#{@content.literal}[]"
      end

      private
        def check_with_method value, method_name
          if value.is_a? ::Array
            results = value.map.with_index do |element, index|
              [index, @content.public_send(method_name, element)]
            end

            errors = results.map do |index, result|
              if result.type_error?
                ["array[#{index}]", result]
              else
                nil
              end
            end.compact

            if errors.empty?
              Camille::Checked.new(fingerprint, results.map{|_, checked| checked.value})
            else
              Camille::TypeError.new(**errors.to_h)
            end
          else
            Camille::TypeError.new("Expected array, got #{value.inspect}.")
          end
        end
    end
  end
end