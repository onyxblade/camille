module Camille
  module Types
    class Array < Camille::BasicType
      attr_reader :content

      def initialize content
        @content = Camille::Type.instance content
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@content.fingerprint}"
      end

      def transform_and_check value
        result = check value
        if result.type_error?
          [result, nil]
        else
          [nil, result.value]
        end
      end

      def check value
        if value.is_a? ::Array
          results = value.map.with_index do |element, index|
            [index, @content.check(element)]
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

      def literal
        "#{@content.literal}[]"
      end
    end
  end
end