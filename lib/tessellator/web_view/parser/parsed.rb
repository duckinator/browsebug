class Tessellator::WebView::Parser
  class Parsed
    attr_accessor :error, :document, :css, :title

    def initialize(can_render: true, error: false, title: nil, document:, css: nil)
      @can_render = can_render
      @error = error
      @document  = document
      @css   = css

      @title =
        if title
          title
        elsif document.respond_to?(:title) && document.title
          document.title
        else
          nil
        end
    end

    def renderable?
      @can_render
    end

    def error?
      !!@error
    end
  end
end
