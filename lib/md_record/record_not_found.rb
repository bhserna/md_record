# frozen_string_literal: true

module MdRecord
  class RecordNotFound < StandardError
    attr_reader :model, :slug

    def initialize(message = nil, model: nil, slug: nil)
      @model = model
      @slug = slug
      super(message || default_message)
    end

    private

    def default_message
      if model && slug
        "Couldn't find #{model} with slug '#{slug}'"
      elsif model
        "Couldn't find #{model}"
      else
        "Record not found"
      end
    end
  end
end
