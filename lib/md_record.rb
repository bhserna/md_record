# frozen_string_literal: true

require "active_model"
require "active_support/concern"
require "redcarpet"
require "yaml"
require "pathname"

require_relative "md_record/version"
require_relative "md_record/record_not_found"
require_relative "md_record/frontmatter_parser"
require_relative "md_record/markdown_renderer"
require_relative "md_record/loader"
require_relative "md_record/categorized_loader"
require_relative "md_record/category"
require_relative "md_record/base"
require_relative "md_record/categorizable"

require_relative "md_record/railtie" if defined?(Rails::Railtie)

module MdRecord
end
