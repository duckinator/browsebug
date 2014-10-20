require 'spinny'
require 'cairo'
require 'pango'

class Tessellator::WebView::Renderer::ElementRenderer::Element
  attr_reader :surface, :context, :element, :stylesheets

  def initialize(surface:, context:, element:, stylesheets:)
    @surface      = surface
    @context      = context
    @element      = element
    @stylesheets  = stylesheets
  end

  def make_layout(text)
    layout = context.create_pango_layout
    layout.text = text
    layout.font_description = Pango::FontDescription.new("Serif 20")
    context.update_pango_layout(layout)
    layout
  end

  alias_method :render, :instance_eval
end
