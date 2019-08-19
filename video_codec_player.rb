begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

require_relative "lib/video_codec"

class Window < CyberarmEngine::Engine
  def setup
    self.show_cursor = true
    push_state(Player)
  end
end

class Player < CyberarmEngine::GuiState
  def setup
    @video = VideoCodec::Reader.new(file: "data/out.rcv")
    @current_frame = 0
    @last_change = 0
    @frame_time = 1000.0 / @video.framerate

    @accumulator= 0
    @last_frame = Gosu.milliseconds
    @playing = false

    background 0xff222222

    flow do
      button("Play") { @playing = true }
      button("Pause"){ @playing = false }
      button("Exit") { window.close }
    end
    @label = label "Frame #{@current_frame}/#{@video.frames.size} (#{@video.framerate} fps)"
  end

  def draw
    super

    @video.frames[@current_frame].draw(10, 100, Float::INFINITY)
  end

  def update
    super

    if @playing
      if @accumulator - @last_change >= @frame_time
        @last_change = @accumulator
        @current_frame += 1
        @current_frame = 0 if @current_frame == @video.frames.size
      end

      @label.value = "Frame #{@current_frame}/#{@video.frames.size} (#{@video.framerate} fps)"
      @accumulator += Gosu.milliseconds - @last_frame
    end

    @last_frame = Gosu.milliseconds
  end
end

Window.new(resizable: true).show