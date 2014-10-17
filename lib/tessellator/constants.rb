require 'tessellator/version'

module Tessellator
  BROWSER_NAME = "Tessellator"
  USER_AGENT = "#{BROWSER_NAME}/#{VERSION} #{RUBY_ENGINE}/#{RUBY_VERSION}"

  # The number of HTTP redirects before bailing.
  HTTP_REDIRECT_LIMIT = 10
end
