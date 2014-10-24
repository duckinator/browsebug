class Tessellator::WebView::Renderer::Node::Block < Tessellator::WebView::Renderer::Node
  def make_layout(text)
    layout = context.create_pango_layout
    layout.text = text
    layout.font_description = Pango::FontDescription.new("Serif 20")
    context.update_pango_layout(layout)
    layout
  end

  def render_text(text, x, y, width, height)
    context.move_to(10, 50)
    context.line_to(450, 50)
    context.stroke_preserve
    path = context.copy_path_flat

    context.line_width = 1
    context.new_path
    layout = make_layout(text)
    context.pango_layout_line_path(layout.get_line(0))
    context.map_path_onto(path)

    context.set_source_rgba([0, 0, 0, 1])
    context.fill_preserve
    context.stroke
  end

  def render_at(x, y, width, height)
    element.children.map do |el|
      case el
      when Nokogiri::XML::Text
        puts "Hi: #{el.inner_text.inspect}"
        render_text(el.inner_text, x, y, width, height)
      when Nokogiri::XML::Element
        renderer.render(el, x, y, width, height)
      end

      el.children.map do |el2|
        renderer.render(el2, x, y, width, height)
      end
    end
  end
end
