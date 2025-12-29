# frozen_string_literal: true

require "erb"

module MdRecord
  class MarkdownRenderer < Redcarpet::Render::HTML
    def image(src, title, alt_text)
      if src && !src.start_with?("http://", "https://", "/")
        src = resolve_asset_path(src)
      end

      title_attr = title && !title.empty? ? %( title="#{title}") : ""
      %(<img src="#{src}" alt="#{alt_text}"#{title_attr}>)
    end

    def block_code(code, language)
      %(<pre><code>#{ERB::Util.html_escape(code)}</code></pre>)
    end

    private

    def resolve_asset_path(src)
      if defined?(ActionController::Base)
        ActionController::Base.helpers.asset_path(src)
      else
        src
      end
    end
  end
end
