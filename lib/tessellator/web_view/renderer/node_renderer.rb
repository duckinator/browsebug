require 'tessellator/version'
require 'spinny'
require 'cairo'
require 'pango'
require 'observer'

class Tessellator::WebView::Renderer::NodeRenderer < Struct.new(:surface, :context)
  require 'tessellator/web_view/renderer/node'

  ELEMENT_MAP = {
    'img'   => :image,
    'a'     => :anchor,
    'span'  => :inline,
    'ol'    => :ordered_list,
    'ul'    => :unordered_list,
    'li'    => :list_item,
    'div'   => :block,
  }

  require "tessellator/web_view/renderer/node"
  require "tessellator/web_view/renderer/node/block"

  ELEMENT_MAP.values.each do |type|
    require "tessellator/web_view/renderer/node/#{type.to_s}"
  end

  def render_document(document)
    dtd, root_element = document.children

    render(root_element, 0, 0, surface.width, surface.height)
  end

  def render(element, x, y, width, height)
    stylesheets = [] # ????

    puts "#{element_class(element).name}(..., ..., element, ...)"
    el = element_class(element).new(surface, context, element, stylesheets)
    el.render_at(x, y, width, height)
  end

  private
  def element_class(element)
    name = snake_to_camel(element_class_name(element.name))

    node = Tessellator::WebView::Renderer::Node

    if name.empty? || !node.const_defined?(name)
      $stderr.puts "WARNING: Defaulting to generic block element for `#{element.name}'."
      name = :Block
    end

    node.const_get(name)
  end

  def element_class_name(name)
    (ELEMENT_MAP.find {|k, v| k === name} || []).last
  end

  def snake_to_camel(str)
    str.to_s.capitalize.gsub(/_(.)/) { $1.upcase }
  end
end
