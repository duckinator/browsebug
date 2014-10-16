require 'tessellator/version'
require 'httparty'
require 'mime-types'

class Tessellator::WebView::Parser
  class Parsed
    attr_accessor :error, :document, :css, :title

    def initialize(can_render: true, error: false, title: nil, document:, css: nil)
      @can_render = can_render
      @error = error
      @document  = document
      @css   = css

      @title =
        if title
          title
        elsif document.respond_to?(:title) && document.title
          document.title
        else
          nil
        end
    end

    def renderable?
      @can_render
    end

    def error?
      !!@error
    end
  end

  MIME_MAPPING = {
    # Text-based files.
    'text/html'         => :html,
    'text/plain'        => :text,
    #'text/css'          => :css,
    #'text/javascript'   => :javascript,
    #'text/xml'          => :xml,

    # Multipurpose files.
    #'application/xhtml' => :xhtml,

    #'application/xml'   => :xml,
    #'application/xml-dtd' => :dtd,

    #'application/atom+xml' => :atom,
    #'application/rss+xml'  => :rss,

    #'application/json'  => :json,
    #'application/javascript' => :javascript,
    'application/octet-stream' => :octet_stream,

    # Images.
    #'image/gif'         => :gif,
    #'image/jpeg'        => :jpeg,
    #'image/pjpeg'       => :jpeg,
    #'image/png'         => :png,
    #'image/svg+xml'     => :svg,

    # Defaults
    :default => :octet_stream,
  }

  def initialize(method, url, parameters, response)
    @response = response
    headers = response.headers

    # TODO: Be a little bit more robust, possibly?
    mime_type = MIME::Types[headers['content-type']].first
    p mime_type
    p response.headers

    @method = MIME_MAPPING[mime_type.simplified]
  end

  def self.parse(*args)
    self.new(*args).parse!
  end

  def parse!
    $stderr.puts "[Parser##{@method}]"

    send(@method, @response)
  end

  def text(response)
    html("<pre>#{response.body}</pre>")
  end

  def html(response)
    Parsed.new(document: Nokogiri::HTML(response.body))
  end

  def xhtml(response)
    Parsed.new(document: Nokogiri::XHTML(response.body))
  end

  def octet_stream(response)
    Parsed.new(error: text("Parser#octet_stream: No idea how to handle downloads."), document: nil)
  end
end
