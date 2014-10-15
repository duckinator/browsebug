require 'tessellator/version'
require 'httparty'

class Tessellator::WebView::HTMLParser < HTTParty::Parser
  SupportedFormats.merge!('text/html'         => :html,
                          'application/xhtml' => :html)

  def html
    $stderr.puts "[HTML parse]"

    Nokogiri::HTML(body)
  end
end
