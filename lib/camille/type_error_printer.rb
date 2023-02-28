module Camille
  class TypeErrorPrinter
    INDENTATION = 2

    def initialize error
      @error = error
    end

    def print io = STDOUT
      if @error.basic?
        io.puts @error.message
      else
        print_composite_error io, @error, 0
      end
    end

    private
      def print_composite_error io, error, indentation
        error.components.each do |key, error|
          if error.basic?
            io.puts ' ' * indentation + "#{key}: #{error.message}"
          else
            io.puts ' ' * indentation + "#{key}:"
            print_composite_error io, error, indentation + 2
          end
        end
      end
  end
end