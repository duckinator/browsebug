class Tessellator::WebView::Renderer::Node::Block < Tessellator::WebView::Renderer::Node
  def make_layout(text)
    layout = context.create_pango_layout
    layout.text = text
    layout.font_description = Pango::FontDescription.new("Serif 20")
    context.update_pango_layout(layout)
    layout
  end

  def render_at(x, y, width, height)
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
end
