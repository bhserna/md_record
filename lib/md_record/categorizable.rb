# frozen_string_literal: true

module MdRecord
  module Categorizable
    extend ActiveSupport::Concern

    included do
      attr_accessor :category
    end

    class_methods do
      def md_record_categories(categories)
        @md_record_categories = categories
      end

      def loader
        MdRecord::CategorizedLoader.new(
          path: resolve_path(md_record_path),
          categories: @md_record_categories
        )
      end

      def parse(file, category:)
        super(file).tap { |doc| doc.category = category }
      end

      def all
        loader.load { |file, category| parse(file, category: category) }
      end

      def published
        @published ||= all.select(&:published?)
      end

      def categories
        @md_record_categories.map do |key, config|
          Category.new(
            key: key,
            name: config[:name],
            position: config[:position]
          )
        end.sort_by(&:position)
      end
    end

    def category?(other)
      key = other.is_a?(Category) ? other.key : other
      category == key
    end

    def category_name
      self.class.instance_variable_get(:@md_record_categories).dig(category, :name) || category.to_s.tr("-_", " ").capitalize
    end
  end
end
