require 'tessellator/version'

class Float
  def self.randomize_method(method_name)
    original_method_name = "original_#{method_name.to_s}".to_sym

    alias_method original_method_name, method_name

    define_method(method_name) do |other|
      variance = $VARIANCE
      variance = other if variance == 'other'

      offset = rand.send(original_method_name, rand(variance))
      offset = rand(2) ? offset : -offset

      offset = 0 if $VARIANCE == 0

      send(original_method_name, other).send(original_method_name, offset)
    end
  end

  randomize_method(:+)
  randomize_method(:-)
end

module Tessellator
  require 'tessellator/constants'
  require 'tessellator/debug'
  require 'tessellator/web_view'
end

