require 'tessellator/version'
require 'tessellator/web_view/parser'
require 'spinny'
require 'httparty'
require 'nokogiri'

class Tessellator::WebView::Fetcher
  include HTTParty

  class << self
    def fetch(method, url, parameters=default)
      method = normalize_method(method)

      if method == :get && parameters.default?
        url, parameters = url.split('?', 2)
        parameters = parse_parameters(parameters)
      end

      $stderr.puts "[fetch: #{method} #{url} (#{parameters.inspect})]"

      options = {
        headers: {'User-Agent' => Tessellator::USER_AGENT},
      }

      send(method, url, options)
    end

    private
    def normalize_method(method)
      case method
      when /get/i
        :get
      #when /post/i
      #  :post
      else
        raise NotImplementedError, "cannot handle HTTP method: #{method}"
      end
    end

    def parse_parameters(url)
    end
  end
end
