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

  def render(element)
    stylesheets = [] # ????

    puts "#{element_class(element).name}(..., ..., element, ...)"
    element_class(element).new(surface, context, element, stylesheets)
  end

  def self.on(name, &block)
    define_method(name) do |element, stylesheets=[]|
      Element.new(
        surface: @surface,
        context: @context,
        element: element,
        stylesheets: stylesheets).render(&block)
    end
  end

  on(:document) do
    context.set_source_color(:white)
    context.paint

    context.move_to(10, 50)
    context.line_to(450, 50)
    context.stroke_preserve
    path = context.copy_path_flat

    context.line_width = 1
    context.new_path
    layout = make_layout(element.to_s)
    context.pango_layout_line_path(layout.get_line(0))
    context.map_path_onto(path)

    context.set_source_rgba([0, 0, 0, 1])
    context.fill_preserve
    context.stroke
  end

  private
  def element_class(element)
    name = snake_to_camel(element_class_name(element.name))

    node = Tessellator::WebView::Renderer::Node
p node
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
