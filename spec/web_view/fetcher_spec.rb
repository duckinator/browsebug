require 'spec_helper'
require 'base64'

describe Tessellator::WebView::Fetcher do
  # TODO: HTTP URIs
  #it 'can fetch HTTP URIs' do
  # #...
  #end

  # Data URIs
  describe 'Data URIs' do
    doc_source = '<p>Hello, world!</p>'
    base64_doc_source = Base64.encode64(doc_source)

    it 'can fetch plaintext Data URIs with a character set' do
      doc = Tessellator::WebView::Fetcher.fetch('[unused]', "data:text/html;charset=utf-8,#{doc_source}")
      doc.headers['content-type'].split(';').map(&:strip).must_equal ['text/html', 'charset=utf-8']
      doc.body.must_equal doc_source
    end

    it 'can fetch plaintext Data URIs without a character set' do
      doc = Tessellator::WebView::Fetcher.fetch('[unused]', "data:text/html,#{doc_source}")
      doc.headers['content-type'].must_equal 'text/html'
      doc.body.must_equal doc_source
    end

    it 'can fetch base64-encoded Data URIs with a character set' do
      doc = Tessellator::WebView::Fetcher.fetch('[unused]', "data:text/html;charset=utf-8;base64,#{base64_doc_source}")
      doc.headers['content-type'].split(';').map(&:strip).must_equal ['text/html', 'charset=utf-8']
      doc.body.must_equal doc_source
    end

    it 'can fetch base64-encoded Data URIs without a character set' do
      doc = Tessellator::WebView::Fetcher.fetch('[unused]', "data:text/html;base64,#{base64_doc_source}")
      doc.headers['content-type'].must_equal 'text/html'
      doc.body.must_equal doc_source
    end
  end
end
