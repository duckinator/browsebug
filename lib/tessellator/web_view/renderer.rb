require 'tessellator/version'
require 'spinny'
require 'cairo'
require 'pango'
require 'observer'

class Tessellator::WebView::Renderer
  include Observable

  def initialize(surface)
    @surface = surface

    #Spinny::Utilities.caller_binding
  end

  def make_layout(cr, text)
    layout = cr.create_pango_layout
    layout.text = text
    layout.font_description = Pango::FontDescription.new("Serif 20")
    cr.update_pango_layout(layout)
    layout
  end

  def render(parsed)
    debug_print_call

    doc = (parsed.error || parsed.document)

    head = doc.xpath '//head'
    body = doc.xpath '//body'

    text = body.to_s

    cr = Cairo::Context.new(@surface)

    cr.set_source_color(:white)
    cr.paint

    cr.move_to(10, 50)
    cr.line_to(450, 50)
    cr.stroke_preserve
    path = cr.copy_path_flat

    cr.line_width = 1
    cr.new_path
    layout = make_layout(cr, text)
    cr.pango_layout_line_path(layout.get_line(0))
    cr.map_path_onto(path)

    cr.set_source_rgba([0, 0, 0, 1])
    cr.fill_preserve
    cr.stroke

    cr.show_page

    changed(true)
    notify_observers(self)
  end
end
