# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "md_record"
require "minitest/autorun"

# Test fixtures path
FIXTURES_PATH = File.expand_path("fixtures", __dir__)

# Test model for MdRecord::Base
class Post < MdRecord::Base
  md_record_path File.join(FIXTURES_PATH, "posts")
end

# Test model for MdRecord::Categorizable
class Guide < MdRecord::Base
  include MdRecord::Categorizable

  md_record_path File.join(FIXTURES_PATH, "guides")

  md_record_categories(
    "getting-started" => { name: "Getting Started", position: 1 },
    "advanced" => { name: "Advanced", position: 2 }
  )
end
