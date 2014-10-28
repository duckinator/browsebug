require 'tessellator/version'
require 'tessellator/debug'
require 'tessellator/web_view/parser'
require 'spinny'
require 'httparty'
require 'nokogiri'

class Tessellator::WebView::Fetcher
  require 'tessellator/web_view/fetcher/http_request'

  class << self
    include Tessellator::Debug

    def fetch(method, url, parameters={})
      debug_print_call

      HTTPRequest.request(method, url, parameters)
    end
  end
end
