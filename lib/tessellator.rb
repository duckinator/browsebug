require 'tessellator/version'

class Float
  alias :oldplus :+
  def +(other)
    variance = $VARIANCE
    variance = other if variance == 'other'

    offset = rand.oldplus(rand(variance))
    offset = rand(2) ? offset : -offset

    oldplus(other).oldplus(offset)
  end
end

module Tessellator
  require 'tessellator/constants'
  require 'tessellator/debug'
  require 'tessellator/web_view'
end

