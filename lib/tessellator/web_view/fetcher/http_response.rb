require 'tessellator/version'
require 'spinny'
require 'uri'
require 'net/https'

class Tessellator::WebView::Fetcher
  class HTTPResponse < Struct.new(:body, :headers, :raw)
    def initialize(body: default, headers: {}, raw:)
      if body.default?
        p raw
        p raw.read_header
      end

      super(body, headers, raw)
    end
  end
end
