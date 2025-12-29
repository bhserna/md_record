# frozen_string_literal: true

module MdRecord
  class Category
    attr_reader :key, :name, :position

    def initialize(key:, name:, position:)
      @key = key
      @name = name
      @position = position
    end

    def to_param
      key
    end
  end
end
