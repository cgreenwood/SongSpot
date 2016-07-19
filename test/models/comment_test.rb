require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = Comment.new(body: 'Blah Blah Blah Blah Blah')
  end

  test 'should be valid' do
    assert @comment.valid?
  end

  test 'body should be present' do
    @comment.body = '        '
    assert_not @comment.valid?
  end

  test 'body should be < 255' do
    @comment.body = 'a' * 256
    assert_not @comment.valid?
  end

end
