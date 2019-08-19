module VideoCodec
  class Palette
    def initialize
      @counter = 0
      @colors = {} # index => color
      @index  = {} # color => index
    end

    def load(data)
    end

    def add(color)
      index = @counter
      @index[color] = @counter
      @counter += 1

      return index
    end

    def add_hex(hex_color)
      index = @counter
      @colors[index] = hex_color
      @counter += 1

      return index
    end

    def index_of?(color)
      if index = @index[color]
        index
      else
        add(color)
      end
    end

    def color_of?(index)
      @colors[index]
    end

    def encode
      buffer = StringIO.new
      @index.each do |color, index|
        buffer.write "#{color.hex},"
      end

      buffer.string
    end
  end
end