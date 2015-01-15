require 'tessellator/debug'
require 'cairo'
require 'pango'

class Tessellator::WebView::Renderer::Node < Struct.new(:surface, :context, :element, :stylesheets, :x, :y, :width, :height, :background_rgb)
  include Tessellator::Debug

  def initialize(surface, context, element, stylesheets,
                 x=0, y=0, width=surface.width, height=surface.height,
                 background_rgb=random_rgb)

    super(surface, context, element, stylesheets, x, y, width, height, background_rgb)

    scary_kludgebucket
  end

  def luminance(rgb)
    r, g, b = rgb

    # From http://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
    (0.299 * r + 0.587 * g + 0.114 * b)
  end

  def color_difference(a, b)
    a, b = a.map(&:to_f), b.map(&:to_f)

    a.zip(b).map{|l, r| [l, r].max - [l,r].min}.reduce(:+)
  end

  # I couldn't figure out the appropriate value from http://www.w3.org/TR/WCAG20/#contrast-ratiodef
  # So I went with 1.0 because it resulted in pretty colors.
  def good_foreground?(rgb)
    diff = color_difference(background_rgb, rgb)

    debug diff.inspect

    diff > 1.0
  end

  def random_rgb
    rgb = Array.new(3) { rand }

    debug rgb.inspect

    rgb
  end

  def random_foreground
    rgb = nil

    loop do
      rgb = random_rgb
      break if good_foreground?(rgb)
    end

    rgb
  end

  # FIXME: Resolve tessellator#4, and then replace Node#scary_kludgebucket.
  def scary_kludgebucket
    # Actually *get* the stylesheets, then fix these shenanigans.
    @display = 'block'
    @display = 'none' if %w[head script style].include?(element.name)

    # Once stylesheets are being passed around, set the background *correctly*.
    # Also figure out where this should be actually set.
    if element.name == 'body'
      context.set_source_color(background_rgb)
      context.paint
    end
  end
  private :scary_kludgebucket

  def render!
    render_at(x, y, width, height)
  end

  def render_element(el, x, y, width, height)
    self.class.new(surface, context, el, stylesheets, x, y, width, height, background_rgb).render!
  end


  def make_layout(text)
    debug_print_call

    layout = context.create_pango_layout
    layout.text = text

    serif_or_sans = rand(2).zero? ? 'Sans Serif' : 'Serif'
    font_size     = rand(30) + 10

    layout.font_description = Pango::FontDescription.new("#{serif_or_sans} #{font_size}")
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

    random_negate = ->(x) { rand(1) == 1 ? x : -x }
    random_first  = random_negate.(rand(500)) + 250
    random_second = random_negate.(rand(500)) + 250

    context.move_to(x, y + layout_height + random_first)
    context.line_to(width, x + layout_height + random_second)

    context.stroke_preserve # This apparently underlines the text?
    path = context.copy_path_flat

    context.line_width = 1
    context.new_path

    #context.pango_layout_line_path(layout.get_line(0))

    layout.lines.each do |line|
      context.pango_layout_line_path(line)
    end

    context.map_path_onto(path)

    context.set_source_rgba(random_foreground)
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
