# frozen_string_literal: true

require "date"

module MdRecord
  class FrontmatterParser
    attr_reader :file_path, :frontmatter, :markdown_content

    def initialize(file_path)
      @file_path = file_path
      @frontmatter = {}
    end

    def slug
      File.basename(file_path, ".md")
    end

    def title
      frontmatter.fetch("title", slug.titleize)
    end

    def content
      markdown_content || raw_content
    end

    def published
      frontmatter.fetch("published", false)
    end

    def parse!
      parse_frontmatter!
      self
    end

    private

    def raw_content
      @raw_content ||= File.read(file_path)
    end

    def parse_frontmatter!
      if raw_content =~ /\A---\s*\n(.*?)\n---\s*\n(.*)\z/m
        @frontmatter = YAML.safe_load($1, permitted_classes: [Date, Time])
        @markdown_content = $2
      end
    end
  end
end
