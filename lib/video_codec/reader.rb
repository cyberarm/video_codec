module VideoCodec
  class Reader
    def initialize(file:)
      @file = file
      @frames = []
      @palette = Palette.new
      @parse_succeeded = false

      @version   = nil
      @width     = nil
      @height    = nil
      @framerate = nil

      parse
    end

    def parse
      string = decompress(File.read(@file))
      string.lines.each do |line|
        case line[0..25].split(":").first
        when "header"
          parse_header(line)
        when "palette"
          parse_palette(line)
        when "frame"
          parse_frame(line)
        end
      end

      @parse_succeeded
    end

    def parse_header(string)
      parts = string.split("#").first.sub("header:", "").split(",")
      parts.each do |part|
        list = part.split(":")
        case list.first
        when "v"
          @version = Integer(list.last)
        when "w"
          @width = Integer(list.last)
        when "h"
          @height = Integer(list.last)
        when "f"
          @framerate = Float(list.last)
        end
      end
    end

    def parse_palette(string)
      parts = string.sub("palette:", "").split(",")
      parts.each do |part|
        @palette.add_hex(part.to_i(16))
      end
    end

    def parse_frame(string)
      puts "Decoding frame: #{@frames.size}"
      parts = string.sub("frame:", "").split(",").map { |n| Integer(n) }
      @frames << Frame.new(palette: @palette, width: @width, height: @height, data: parts)
    end

    def decompress(string)
      Zlib::Inflate.inflate(string)
    end

    def frames
      @frames
    end

    def framerate
      @framerate
    end
  end
end