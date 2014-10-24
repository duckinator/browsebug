require 'tessellator/version'
require 'spinny'
require 'cairo'
require 'pango'
require 'observer'

class Tessellator::WebView::Renderer
  require 'tessellator/web_view/renderer/node_renderer'

  include Observable

  def initialize(surface)
    @surface  = surface
    @context  = Cairo::Context.new(surface)
    @elements = NodeRenderer.new(surface, @context)
  end

  def render(parsed)
    debug_print_call

    doc = (parsed.error || parsed.document)

    @elements.render(doc)

#    head = doc.xpath '//head'
#    body = doc.xpath '//body'

    @context.show_page

    changed(true)
    notify_observers(self)
  end

  def inspect
    "#<#{self.class.name} surface=#{@surface.inspect}>"
  end
end
