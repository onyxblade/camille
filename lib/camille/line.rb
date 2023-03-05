module Camille
  # lines with indentation
  class Line
    attr_reader :string, :indent

    def initialize string, indent = 0
      @string = string
      @indent = indent
    end

    def do_indent
      @indent += 2
      self
    end

    def == other
      @string == other.string && @indent == other.indent
    end

    def prepend str
      @string = str + @string
      self
    end

    def append str
      @string = @string + str
      self
    end

    def to_s
      ' ' * @indent + @string
    end
  end
end