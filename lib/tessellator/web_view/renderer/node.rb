require 'spinny'
require 'cairo'
require 'pango'

class Tessellator::WebView::Renderer::Node < Struct.new(:surface, :context, :element, :stylesheets, :renderer)
  def make_layout(text)
    layout = context.create_pango_layout
    layout.text = text
    layout.font_description = Pango::FontDescription.new("Serif 20")
    context.update_pango_layout(layout)
    layout
  end

  def render_at(x, y, width, height)
    raise NotImplementedError
  end
end
