module Gosu
  class Color
    def hex
      _alpha = "%02x" % alpha
      _red   = "%02x" % red
      _green = "%02x" % green
      _blue  = "%02x" % blue

      "#{_alpha}#{_red}#{_green}#{_blue}"
    end
  end
end