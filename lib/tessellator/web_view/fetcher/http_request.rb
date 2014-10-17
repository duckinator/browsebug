require 'tessellator/version'
require 'spinny'
require 'uri'
require 'net/https'

class Tessellator::WebView::Fetcher
  require 'tessellator/web_view/fetcher/http_response'

  class HTTPRequest
    MethodError = Class.new(ArgumentError)
    RedirectLimitError = Class.new(StandardError)

    DEFAULT_HEADERS = {
      'User-Agent' => Tessellator::USER_AGENT,
    }

    HTTP_METHODS = %w[
      get head post put delete options trace patch
    ]

    class << self
      def request(method, url, parameters, options={})
        HTTPResponse.new(raw: fetch(method, url, parameters, options))
      end

      private
      def method_constant(method)
        method = method.to_s.downcase

        raise MethodError, "invalid HTTP method: #{method}" unless HTTP_METHODS.include?(method)

        Net::HTTP.const_get(method.capitalize)
      end

      def fetch(method, url, parameters, options, limit = Tessellator::HTTP_REDIRECT_LIMIT)
        # TODO: Actually handle this exception.
        if limit <= 0
          raise RedirectLimitError, "request exceeded redirect limit (#{Tessellator::HTTP_REDIRECT_LIMIT})."
        end

        uri = URI(url)

        options[:use_ssl] = uri.scheme == 'https'
        options[:ssl_version] = 'TLSv1' if options[:use_ssl]

        Net::HTTP.start(uri.host, uri.port, options) do |http|
          request = Net::HTTP::Get.new uri

          DEFAULT_HEADERS.each do |header, value|
            request[header] = value
          end

          (options[:headers] || []).each do |header, value|
            request[header] = value
          end

          response = http.request request

          if response.is_a?(Net::HTTPRedirection)
            if Tessellator.debug
              $stderr.puts "[DEBUG] #{uri} redirects to #{response['location']}."
            end

            if response['location'].start_with?('/')
              location = uri.dup
              location.path = response['location']

              # TODO: Figure out of querystrings are supposed to be passed along
              #       with redirects. If not, clear them here!
            else
              location = response['location']
            end

            return fetch(method, location.to_s, parameters, options, limit - 1)
          end

          response
        end
      end
    end
  end
end
