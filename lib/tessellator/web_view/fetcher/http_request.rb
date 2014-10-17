require 'tessellator/version'
require 'spinny'
require 'uri'
require 'net/https'

class Tessellator::WebView::Fetcher
  require 'tessellator/web_view/fetcher/http_response'

  class HTTPRequest
    MethodError = Class.new(ArgumentError)

    DEFAULT_HEADERS = {
      'User-Agent' => Tessellator::USER_AGENT,
    }

    HTTP_METHODS = %w[
      get head post put delete options trace patch
    ]

    class << self
      def request(method, url, parameters, options={})
        uri = URI(url)

        options[:use_ssl] = uri.scheme == 'https'
        options[:ssl_version] = 'TLSv1' if options[:use_ssl]

        HTTPResponse.new(raw: send_request(method, uri, parameters, options))
      end

      private
      def method_constant(method)
        method = method.to_s.downcase

        raise MethodError, "invalid HTTP method: #{method}" unless HTTP_METHODS.include?(method)

        Net::HTTP.const_get(method.capitalize)
      end

      def send_request(method, uri, parameters, options)
        Net::HTTP.start(uri.host, uri.port, options) do |http|
          request = Net::HTTP::Get.new uri

          response = http.request request
          p response.methods - Object.new.methods

          response
        end
      end
    end
  end
end
