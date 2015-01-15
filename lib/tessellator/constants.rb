require 'tessellator/version'

module Tessellator
  BROWSER_NAME = "Browsebug"
  USER_AGENT = "#{BROWSER_NAME}/#{VERSION} #{RUBY_ENGINE}/#{RUBY_VERSION}"

  # The number of HTTP redirects before bailing.
  HTTP_REDIRECT_LIMIT = 10

  # Location of assets/pages
  ASSETS_PATH = File.expand_path('../../assets/', File.dirname(__FILE__))
  PAGES_PATH  = File.expand_path('./pages/', ASSETS_PATH)
end
