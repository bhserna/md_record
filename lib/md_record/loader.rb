# frozen_string_literal: true

module MdRecord
  class Loader
    def initialize(path:)
      @path = Pathname.new(path).expand_path
    end

    def load
      markdown_files.map { |file| yield file }
    end

    private

    def markdown_files
      Dir.glob(@path.join("*.md"))
    end
  end
end
