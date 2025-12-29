# frozen_string_literal: true

require_relative "lib/md_record/version"

Gem::Specification.new do |spec|
  spec.name = "md_record"
  spec.version = MdRecord::VERSION
  spec.authors = ["Benito Serna"]
  spec.email = ["bhserna@gmail.com"]

  spec.summary = "File-backed models for Rails"
  spec.description = "ActiveRecord-like interface for markdown files with YAML frontmatter"
  spec.homepage = "https://github.com/bhserna/md_record"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 7.0"
  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "redcarpet", ">= 3.0"
end
