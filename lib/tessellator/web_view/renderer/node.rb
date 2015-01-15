require 'tessellator/debug'
require 'cairo'
require 'pango'

class Tessellator::WebView::Renderer::Node < Struct.new(:surface, :context, :element, :stylesheets, :x, :y, :width, :height)
  include Tessellator::Debug

  def initialize(surface, context, element, stylesheets,
                 x=0, y=0, width=surface.width, height=surface.height)

    super(surface, context, element, stylesheets, x, y, width, height)

    scary_kludgebucket
  end

  def random_rgba(r: nil, g: nil, b: nil, a: nil)
    rgba = Array.new(4) { rand }

    # Override random values with the hard-coded rgba values.
    rgba = [r, g, b, a].each_with_index.map{|x, i| x || rgba[i] }

    debug rgba.inspect

    rgba
  end

  # FIXME: Resolve tessellator#4, and then replace Node#scary_kludgebucket.
  def scary_kludgebucket
    # Actually *get* the stylesheets, then fix these shenanigans.
    @display = 'block'
    @display = 'none' if %w[head script style].include?(element.name)

    # Once stylesheets are being passed around, set the background *correctly*.
    # Also figure out where this should be actually set.
    if element.name == 'body'
      context.set_source_color(random_rgba(a: 0.5))
      context.paint
    end
  end
  private :scary_kludgebucket

  def render!
    render_at(x, y, width, height)
  end

  def render_element(el, x, y, width, height)
    self.class.new(surface, context, el, stylesheets, x, y, width, height).render!
  end


  def make_layout(text)
    debug_print_call

    layout = context.create_pango_layout
    layout.text = text
    layout.font_description = Pango::FontDescription.new("Serif 20")
    context.update_pango_layout(layout)

    #p layout.methods
    debug "pixel_size: #{layout.pixel_size.inspect}"
    #puts "methods: #{layout.lines.first.methods.inspect}"
#    exit

    layout
  end

  def render_text(text, x, y, width, height)
    layout = make_layout(text)
    layout_width, layout_height = layout.pixel_size

    context.move_to(x, y + layout_height)
    context.line_to(width, x + layout_height)

    context.stroke_preserve # This apparently underlines the text?
    path = context.copy_path_flat

    context.line_width = 1
    context.new_path

    #context.pango_layout_line_path(layout.get_line(0))

    layout.lines.each do |line|
      context.pango_layout_line_path(line)
    end

    context.map_path_onto(path)

    context.set_source_rgba(random_rgba)
    context.fill_preserve
    context.stroke

    [
      x + (@block_element ? 0 : layout_width),
      y + layout_height,
    ]
  end

  def render_at(x, y, width, height)
    return [x, y] if @display == 'none' # FIXME: See shenanigans in #__kludgebucket. (tessellator#4)

    element.children.map do |el|
      case el
      when Nokogiri::XML::Text
        x, y = render_text(el.inner_text, x, y, width, height)
      when Nokogiri::XML::Element
        render_element(el, x, y, width, height)
      end

      el.children.map do |el2|
        x, y = render_element(el2, x, y, width, height)
      end
    end

    [x, y]
  end
end
