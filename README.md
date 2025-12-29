# MdRecord

File-backed models for Rails. Similar to ActiveRecord but reads from markdown files with YAML frontmatter.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "md_record"
```

And then execute:

```bash
bundle install
```

## Usage

### Basic Model

```ruby
class Post < MdRecord::Base
end
```

By default, files are loaded from `app/views/posts/` (based on model name).

```ruby
Post.all        # All posts
Post.published  # Only published posts
Post.find(slug) # Find by slug or raise MdRecord::RecordNotFound
```

### Custom Path

```ruby
class Article < MdRecord::Base
  md_record_path "content/articles"
end
```

### Categorized Model

```ruby
class Guide < MdRecord::Base
  include MdRecord::Categorizable

  md_record_categories(
    "getting-started" => { name: "Getting Started", position: 1 },
    "advanced" => { name: "Advanced", position: 2 }
  )
end
```

Files are organized in subfolders:
```
app/views/guides/
  getting-started/
    first-steps.md
  advanced/
    custom-config.md
```

```ruby
Guide.categories  # Returns array of MdRecord::Category objects
guide.category?("getting-started")  # Check if guide belongs to category
guide.category_name  # "Getting Started"
```

## File Format

Markdown files with YAML frontmatter:

```markdown
---
title: My Post Title
description: A short description
published: true
published_at: 2024-01-15
position: 1
---

# Content here

Your markdown content...
```

## Attributes

- `slug` - Filename without extension
- `title` - From frontmatter or titleized slug
- `description` - From frontmatter
- `content` - Markdown content
- `published` - Boolean
- `published_at` - Date/Time
- `position` - For ordering

## Methods

### Class Methods

- `all` - Load all records
- `published` - Published records sorted by `published_at` desc
- `find(slug)` - Find by slug, raises `RecordNotFound` if not found

### Instance Methods

- `published?` - Is this record published?
- `to_param` - Returns slug (for URL generation)
- `to_html` - Renders markdown to HTML

### Categorizable Methods

- `categories` - Array of `MdRecord::Category` objects
- `category?(category)` - Check if record belongs to category (accepts Category or string)
- `category_name` - Human-readable category name

## RecordNotFound

`MdRecord::RecordNotFound` is automatically mapped to 404 in Rails (via Railtie).

```ruby
Post.find("non-existent") # raises MdRecord::RecordNotFound
# Rails returns 404
```

## Components

- `MdRecord::Base` - Base class for models
- `MdRecord::Categorizable` - Concern for categorized models
- `MdRecord::Category` - Value object for categories
- `MdRecord::Loader` - Loads files from a directory
- `MdRecord::CategorizedLoader` - Loads files from category subdirectories
- `MdRecord::FrontmatterParser` - Parses YAML frontmatter
- `MdRecord::MarkdownRenderer` - Custom Redcarpet renderer with asset path support
- `MdRecord::RecordNotFound` - Exception for missing records
- `MdRecord::Railtie` - Rails integration (auto-loaded)

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
