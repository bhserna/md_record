# frozen_string_literal: true

module MdRecord
  class CategorizedLoader
    def initialize(path:, categories:)
      @path = Pathname.new(path).expand_path
      @categories = categories
    end

    def load
      @categories.keys.flat_map do |category|
        if category_path(category).directory?
          category_files(category).map { |file| yield file, category }
        else
          []
        end
      end
    end

    private

    def category_files(category)
      Dir.glob(category_path(category).join('*.md'))
    end

    def category_path(category)
      @path.join(category.to_s)
    end
  end
end
