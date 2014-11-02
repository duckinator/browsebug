require 'tessellator/version'
require 'cairo'
require 'observer'

require 'tessellator/kludges'

class Tessellator::WebView
  require 'tessellator/web_view/fetcher'
  require 'tessellator/web_view/renderer'

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

  def can_go_forward
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

  def update(data)
    changed(true)
    notify_observers(self)
  end

  private
  def render_page(method, url, parameters=default)
    if url.nil?
      $stderr.puts "WARNING: render_page() called with nil url. Possible bug?"
      return
    end

    response = Fetcher.fetch(method, url, parameters)
    @location = response.url

    parsed   = Parser.parse(method, url, parameters, response)

    set_title parsed.title

    renderer = Renderer.new(surface)
    renderer.add_observer(self)

    renderer.render(parsed)
  end
end

