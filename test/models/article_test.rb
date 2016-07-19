require 'test_helper'
# Tests for validating an article.
class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = Article.new(title: 'Example Article', text: 'Blah Blah Blah')
  end

  test 'should be valid' do
    assert @article.valid?
  end

  test 'title should be present' do
    @article.title = '       '
    assert_not @article.valid?
  end

  test 'text should be present' do
    @article.text = '        '
    assert_not @article.valid?
  end

  test 'title should be > 5' do
    @article.title = 'a' * 4
    assert_not @article.valid?
  end

  test 'title should be < 128' do
    @article.title = 'a' * 129
    assert_not @article.valid?
  end

  test 'text should be < 5000' do
    @article.text = 'a' * 5001
    assert_not @article.valid?
  end
end
