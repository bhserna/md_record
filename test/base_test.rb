# frozen_string_literal: true

require "test_helper"

class MdRecord::BaseTest < Minitest::Test
  def setup
    # Clear memoized data between tests
    Post.instance_variable_set(:@published, nil)
  end

  def test_all_returns_array_of_records
    posts = Post.all
    assert_kind_of Array, posts
    assert_equal 3, posts.size
  end

  def test_published_returns_only_published_records
    posts = Post.published
    assert_kind_of Array, posts
    assert posts.all?(&:published?)
    assert_equal 2, posts.size
  end

  def test_published_returns_records_sorted_by_published_at_descending
    posts = Post.published
    assert_kind_of Array, posts

    posts.each_cons(2) do |a, b|
      assert a.published_at >= b.published_at
    end
  end

  def test_find_returns_a_record_by_slug
    post = Post.find("hello-world")
    refute_nil post
    assert_equal "hello-world", post.slug
  end

  def test_find_raises_record_not_found_for_non_existent_record
    assert_raises(MdRecord::RecordNotFound) do
      Post.find("non-existent")
    end
  end

  def test_record_not_found_includes_model_and_slug
    error = assert_raises(MdRecord::RecordNotFound) do
      Post.find("non-existent")
    end
    assert_equal "Post", error.model
    assert_equal "non-existent", error.slug
    assert_match(/Couldn't find Post with slug 'non-existent'/, error.message)
  end

  def test_parses_frontmatter_correctly
    post = Post.find("hello-world")
    assert_equal "Hello World", post.title
    assert_equal "My first post", post.description
    refute_nil post.published_at
    assert post.published?
  end

  def test_renders_markdown_to_html
    post = Post.find("hello-world")
    html = post.to_html
    assert_includes html, "<h1"
    assert_includes html, "<p"
  end

  def test_to_param_returns_slug
    post = Post.find("hello-world")
    assert_equal "hello-world", post.to_param
  end

  def test_published_predicate_returns_published_status
    post = Post.find("hello-world")
    assert post.published?
  end
end
