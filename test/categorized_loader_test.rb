# frozen_string_literal: true

require 'test_helper'

class MdRecord::CategorizedLoaderTest < Minitest::Test
  def test_load_returns_results_only_from_existing_category_folders
    path = File.join(FIXTURES_PATH, 'guides')
    categories = {
      'getting-started' => { name: 'Getting Started', position: 1 },
      'non-existent' => { name: 'Non Existent', position: 2 }
    }

    loader = MdRecord::CategorizedLoader.new(path: path, categories: categories)
    results = loader.load { |_file, category| category }

    assert(results.all? { |cat| cat == 'getting-started' })
  end
end
