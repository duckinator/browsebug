require 'tessellator/version'
require 'spinny'
require 'cairo'
require 'pango'
require 'observer'

require 'tessellator/kludges'

class Tessellator::WebView
  require 'tessellator/web_view/fetcher'

  include Observable

  attr_reader :history, :history_index, :location, :surface, :title

  def initialize(width=500, height=500)
    @history = []
    @history_index = 0

    title = nil

    @surface = Cairo::ImageSurface.new(width, height)
  end

  def set_title(title)
    @title = Tessellator::BROWSER_NAME
    @title = "#{title} — #{@title}" if title

    p @title
  end

  def open(url)
    @history_index += 1

    # Append url to @history and truncate.
    @history[@history_index..-1] = [url]

    @location = url

    render_page('GET', url)
  end

  def reload
    render_page(@location)
  end

  def can_go_back
    @history_index > 0
  end

  def  can_go_forward
    @history_index < @history.length
  end

  def go(offset)
    new_index = @history_index + offset

    return false if new_index > @history.length || new_index < 0

    @history_index += offset
    location = @history[@history_index]

    reload
  end

  def go_back
    go(-1)
  end

  def go_forward
    go(+1)
  end

  private
  def render_page(method, url, parameters=default)
    if url.nil?
      $stderr.puts "WARNING: render_page() called with nil url. Possible bug?"
      return
    end

    response = Fetcher.fetch(method, url, parameters)
    parsed   = Parser.parse(method, url, parameters, response)

    render(parsed)
  end

def make_layout(cr, text)
  layout = cr.create_pango_layout
  layout.text = text
  layout.font_description = Pango::FontDescription.new("Serif 20")
  cr.update_pango_layout(layout)
  layout
end

def render(parsed)
  set_title parsed.title

  doc = (parsed.error || parsed.document)

  head = doc.xpath '//head'
  body = doc.xpath '//body'

  text = body.to_s

  $stderr.puts "[render]"

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


def output
  Cairo::ImageSurface.new(500, 500) do |surface|
    render(surface)
    surface.write_to_png("text-on-path.png")
  end
end

#output

