require_relative "lib/video_codec"
require "gosu"

images = []
files = Dir.glob("#{ARGV.first}/*.*")
pp files

if files.size == 0
  puts "No files at #{ARGV.first}"
  exit
end

files.sort_by! { |file| File.basename(file) }

files.each { |file| images << Gosu::Image.new(file) }

VideoCodec::Writer.new(file: "data/out.rcv", images: images, framerate: 24)