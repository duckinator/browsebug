require 'tessellator/version'
require 'tessellator/debug'
require 'tessellator/utilities'
require 'tessellator/web_view/parser'
require 'spinny'
require 'nokogiri'

class Tessellator::WebView::Fetcher
  require 'tessellator/web_view/fetcher/http_request'
  require 'tessellator/web_view/fetcher/internal_request'

  INTERNAL_SCHEMES = %w[about]
  FILE_SCHEMES     = %w[file]
  HTTP_SCHEMES     = %w[https http]
  DATA_SCHEMES     = %w[data]

  class << self
    include Tessellator::Debug

    def fetch(method, url, parameters={})
      debug_print_call

      uri = Tessellator::Utilities.safe_uri(url)

      case uri.scheme
      when *INTERNAL_SCHEMES
        InternalRequest.request(method, url, parameters)
      when *HTTP_SCHEMES, *DATA_SCHEMES # FIXME: Pull out data: URIs. (tessellator#1)
        HTTPRequest.request(method, url, parameters)
      when *FILE_SCHEMES
        # FIXME: Make file:// URLs work. (tessellator#1)
        raise NotImplementedError, "No idea how to handle file:// URLs."
      end
    end
  end
end
