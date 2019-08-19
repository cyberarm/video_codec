require "gosu"

chars = Array("A".."Z")
char_size = 128
chars.each do |char|
  Gosu.render(char_size, char_size) do
    Gosu::Image.from_text(char, char_size).draw(0,0,0)
  end.save("data/images/#{char}.png")
end