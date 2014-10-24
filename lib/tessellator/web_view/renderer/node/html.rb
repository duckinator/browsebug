class Tessellator::WebView::Renderer::Node::Html < Tessellator::WebView::Renderer::Node
  def render_at(x, y, width, height)
    # TODO: Once stylesheets are being passed around, actually set the background color.
    context.set_source_color(:white)
    context.paint

    element.children.map do |el|
      renderer.render(el, x, y, width, height)
    end
  end
end
