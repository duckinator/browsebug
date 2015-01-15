require 'tessellator/version'

class Float
  alias :oldplus :+
  def +(other)
    variance = 3

    offset = rand(variance) + rand
    offset = rand(2) ? offset : -offset

    oldplus(other).oldplus(offset)
  end
end

module Tessellator
  require 'tessellator/constants'
  require 'tessellator/debug'
  require 'tessellator/web_view'
end

