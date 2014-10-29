module Tessellator
  module Utilities
    class << self
      # TODO: Make this less horrifying.
      def sanitized_uri(url)
        old_url ||= nil
        URI(url)
      rescue URI::InvalidURIError => e
        raise e if old_url

        old_url = url
        url = URI.encode(url)

        retry
      end
    end
  end
end
