require 'tessellator/version'
require 'tessellator/debug'
require 'spinny'
require 'mayhaps'
require 'mime-types'

class Tessellator::WebView::Parser
  include Tessellator::Debug

  require 'tessellator/web_view/parser/parsed'

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
  }

  def initialize(method, url, parameters, response)
    @response = response
    headers = response.headers

    # TODO: Be a little bit more robust, possibly?
    mime_type = MIME::Types[headers['content-type']].first


    @method   = MIME_MAPPING[+mime_type.maybe.simplified] || :default
  end

  def self.parse(*args)
    self.new(*args).parse!
  end

  def parse!
    debug_print_call

    send(@method, @response)
  end

  def text(response)
    response = response.dup
    response.body = "<pre>#{response.body}</pre>"

    html(response)
  end

  def html(response)
    Parsed.new(document: Nokogiri::HTML(response.body))
  end

  def xhtml(response)
    Parsed.new(document: Nokogiri::XHTML(response.body))
  end

  def octet_stream(response)
    Parsed.new(error: Nokogiri::HTML("<p>Parser#octet_stream: No idea how to handle downloads.</p>"), document: nil)
  end

  def default(response)
    octet_stream(response)
  end
end
