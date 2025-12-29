# frozen_string_literal: true

module MdRecord
  class Base
    include ActiveModel::Model

    attr_accessor :slug, :title, :content, :published,
                  :published_at, :description, :position

    class << self
      def md_record_path(path = nil)
        @md_record_path = path if path
        @md_record_path || default_path
      end

      def loader
        MdRecord::Loader.new(path: resolve_path(md_record_path))
      end

      def parse(file)
        parser = MdRecord::FrontmatterParser.new(file).parse!

        new(
          slug: parser.slug,
          title: parser.title,
          content: parser.content,
          published: parser.published,
          published_at: parser.frontmatter["published_at"],
          description: parser.frontmatter["description"],
          position: parser.frontmatter.fetch("position", 0)
        )
      end

      def all
        loader.load { |file| parse(file) }
      end

      def published
        @published ||= all.select(&:published?).sort_by(&:published_at).reverse
      end

      def find(slug)
        published.find { |doc| doc.slug == slug } ||
          raise(RecordNotFound.new(model: name, slug: slug))
      end

      private

      def default_path
        "app/views/#{model_name.plural}"
      end

      def resolve_path(path)
        if defined?(Rails.root) && Rails.root
          Rails.root.join(path).to_s
        else
          path
        end
      end
    end

    def published?
      published
    end

    def to_param
      slug
    end

    def to_html
      options = {
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        no_intra_emphasis: true
      }

      renderer = MdRecord::MarkdownRenderer.new(hard_wrap: true)
      markdown = Redcarpet::Markdown.new(renderer, options)
      result = markdown.render(content)

      if result.respond_to?(:html_safe)
        result.html_safe
      else
        result
      end
    end
  end
end
