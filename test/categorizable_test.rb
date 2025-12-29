# frozen_string_literal: true

require "test_helper"

class MdRecord::CategorizableTest < Minitest::Test
  def setup
    # Clear memoized data between tests
    Guide.instance_variable_set(:@published, nil)
  end

  def test_categories_returns_array_of_category_objects
    categories = Guide.categories
    assert_kind_of Array, categories
    assert categories.all? { |c| c.is_a?(MdRecord::Category) }
  end

  def test_categories_returns_categories_sorted_by_position
    categories = Guide.categories
    assert categories.size >= 2

    categories.each_cons(2) do |a, b|
      assert a.position <= b.position
    end
  end

  def test_category_has_key_name_and_position
    category = Guide.categories.first
    assert_respond_to category, :key
    assert_respond_to category, :name
    assert_respond_to category, :position
  end

  def test_category_to_param_returns_key
    category = Guide.categories.first
    assert_equal category.key, category.to_param
  end

  def test_category_returns_the_category_key
    guide = Guide.find("first-steps")
    assert_equal "getting-started", guide.category
  end

  def test_category_predicate_returns_true_for_matching_category
    guide = Guide.find("first-steps")
    assert guide.category?("getting-started")
  end

  def test_category_predicate_returns_false_for_non_matching_category
    guide = Guide.find("first-steps")
    refute guide.category?("advanced")
  end

  def test_category_predicate_accepts_category_object
    guide = Guide.find("first-steps")
    category = Guide.categories.find { |c| c.key == "getting-started" }
    assert guide.category?(category)
  end

  def test_category_name_returns_human_readable_category_name
    guide = Guide.find("first-steps")
    assert_equal "Getting Started", guide.category_name
  end

  def test_published_returns_only_published_records
    guides = Guide.published
    assert guides.all?(&:published?)
  end

  def test_all_returns_guides_from_all_categories
    guides = Guide.all
    assert_equal 3, guides.size
  end
end
