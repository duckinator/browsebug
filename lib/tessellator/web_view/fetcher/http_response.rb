require 'tessellator/version'
require 'spinny'
require 'uri'
require 'net/https'

class Tessellator::WebView::Fetcher
  class HTTPResponse < Struct.new(:body, :headers, :url)
    def initialize(body: default, headers: default, raw:, url:)
      default_for(:headers) { raw.to_hash }
      default_for(:body)    { raw.body    }

      class << headers
        alias_method :old_fetch, :[]
        def [](key)
          ret = old_fetch(key)

          ret = ret.first if ret.is_a?(Array) && ret.length == 1

          ret
        end
      end

      super(body, headers, url)
    end
  end
end
