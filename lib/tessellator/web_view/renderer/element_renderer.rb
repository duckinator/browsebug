require 'tessellator/version'
require 'spinny'
require 'cairo'
require 'pango'
require 'observer'

class Tessellator::WebView::Renderer::ElementRenderer
  require 'tessellator/web_view/renderer/element_renderer/element'

  attr_accessor :surface, :context

  def initialize(surface, context)
    @surface = surface
    @context = context
  end

  def render(element)
    unless respond_to?(element.name)
      raise NotImplementedError, "no handler defined for `#{element.name}' elements."
    end

    puts "#{element.name}(element)"
    send(element.name, element)
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

  on(:p) do
    
  end

  on(:span) do
    
  end
end
