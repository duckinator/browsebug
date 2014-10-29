require 'spinny'
require 'uri'

class Tessellator::WebView::Fetcher
  class InternalRequest
    class << self
      def request(method, url, parameters, options={})
        uri  = Tessellator::Utilities.sanitized_uri(url)
        body = fetch_file(uri)

        data = {
          url:         options['url-override'] || url,
          version:     Tessellator::VERSION,
          user_agent: Tessellator::USER_AGENT,
        }

        if body
          Response.new(body.format(data), {'content-type' => 'text/html'}, data['url'])
        else
          request('GET', 'errors:404', {}, {'url-override' => url})
        end
      end

      def fetch_file(uri)
        filename = uri.opaque + '.html'

        # FIXME: Does this need to be more robust? >.>
        return nil if filename.start_with?('.') || filename.start_with?('/')

        file_path = File.join(Tessellator::PAGES_PATH, uri.scheme, filename)

        return nil unless File.file?(file_path)

        open(file_path).read
      end
    end
  end
end
