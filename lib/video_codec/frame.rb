module VideoCodec
  class Frame
    attr_reader :width, :height, :data
    def initialize(palette:, width:, height:, data:)
      @palette = palette
      @width, @height = width, height
      @data = data

      loki = LokiImageMagick.new(frame: self)
      @image = Gosu::Image.new(loki)
    end

    def color_of?(index)
      @palette.color_of?(index)
    end

    def draw(*args)
      @image.draw(*args)
    end

    class LokiImageMagick
      def initialize(frame:)
        @frame = frame
      end

      def columns
        @frame.width
      end

      def rows
        @frame.height
      end

      def to_blob
        blob = []
        @frame.data.each do |indexed_color|
          color = @frame.color_of?(indexed_color)
          blob.push(color)
        end

        blob.pack("N*")
      end
    end
  end
end