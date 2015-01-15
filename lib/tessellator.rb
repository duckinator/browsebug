require 'tessellator/version'

class Float
  alias :oldplus :+
  def +(other)
    variance = $VARIANCE
    variance = other if variance == 'other'

    offset = rand.oldplus(rand(variance))
    offset = rand(2) ? offset : -offset

    offset = 0 if $VARIANCE == 0

    oldplus(other).oldplus(offset)
  end

  alias :oldminus :-
  def -(other)
    variance = $VARIANCE
    variance = other if variance == 'other'

    offset = rand.oldminus(rand(variance))
    offset = rand(2) ? offset : -offset

    offset = 0 if $VARIANCE == 0

    oldminus(other).oldminus(offset)
  end

end

module Tessellator
  require 'tessellator/constants'
  require 'tessellator/debug'
  require 'tessellator/web_view'
end

