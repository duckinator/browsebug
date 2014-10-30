require 'tessellator/version'
require 'spinny'
require 'uri'
require 'base64'

class Tessellator::WebView::Fetcher
  require 'tessellator/web_view/fetcher/response'

  class DataRequest
    class << self
      def request(method, url, parameters, options={})
        fetch(url, parameters, options)
      end

      private
      def fetch(url, parameters, options)
        if url =~ /^([^:]+):([^;,]+)(;charset=[^;,]+)?(;base64)?,(.*)$/
          scheme, mime_type, charset, base64, data = $1, $2, $3, $4, $5

          charset = charset.split('=').last if charset
        end

        unless scheme == 'data'
          raise ArgumentError, "expected data URI, got #{scheme} URI"
        end

        data = URI.decode(data)
        data = Base64.decode64(data) if base64

        headers = {
          'content-type' => "#{mime_type}"
        }

        headers['content-type'] += "; charset=#{charset}" if charset

        Response.new(data, headers, url)
      end
    end
  end
end
