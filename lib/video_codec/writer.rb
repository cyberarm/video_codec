module VideoCodec
  class Writer
    def initialize(file:, images:, width: nil, height: nil, framerate:)
      @file = file

      @images = images
      @width  = width ? width : @images.first.width
      @height = height ? height : @images.first.height
      @framerate = framerate

      @buffer = StringIO.new
      @palette = Palette.new
      @frames  = []

      encode_video
      save_video
    end

    def encode_video
      @images.each do |image|
        encode(image)
      end


      @buffer.write(header)
      encode_palette
      encode_frames
    end

    def save_video
      File.open(@file, "wb") do |file|
        file.write(compress(@buffer.string))
      end
    end

    def header
      "header:v:0,w:#{@width},h:#{@height},f:#{@framerate.to_f}# #{File.basename(@file)} created: #{Time.now.strftime("%X%z %x")}\n"
    end

    def encode(image)
      puts "Encoding frame #{@frames.size}..."
      bytes = image.to_blob.bytes
      indexed_colors = []

      image.height.times do |y|
        image.width.times do |x|
          a, r, g, b = bytes[(y * image.width + x) * 4, 4]
          indexed_colors << @palette.index_of?(Gosu::Color.new(a.ord, r.ord, g.ord, b.ord))
        end
      end

      @frames << indexed_colors
    end

    def encode_palette
      @buffer.write "palette:#{@palette.encode}\n"
    end

    def encode_frames

      @frames.each do |frame|
        @buffer.write "frame:#{frame.map { |int| int }.join(",")}\n"
      end
    end

    def compress(string)
      Zlib::Deflate.deflate(string)
    end
  end
end