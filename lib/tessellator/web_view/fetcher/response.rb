require 'tessellator/version'
require 'spinny'

class Tessellator::WebView::Fetcher
  class Response < Struct.new(:body, :headers, :url)
    def initialize(body, headers, url)
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
