require 'tessellator/version'
require 'spinny'
require 'cairo'
require 'pango'
require 'observer'

class Tessellator::WebView::Renderer
  include Tessellator::Debug
  include Observable

  require 'tessellator/web_view/renderer/node'

  def initialize(surface)
    @surface  = surface
    @context  = Cairo::Context.new(surface)
  end

  def render(parsed)
    debug_print_call

    document = (parsed.error || parsed.document)

    dtd, root_element = document.children

    Node.new(@surface, @context, document, []).render!

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
