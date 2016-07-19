require 'test_helper'

class BugTest < ActiveSupport::TestCase
  def setup
    @bug = Bug.new(title: 'Example Bug', bug_type: 'Example Type',content: 'Blah Blah Blah')
  end

  test 'should be valid' do
    assert @bug.valid?
  end

  test 'title should be present' do
    @bug.title = '       '
    assert_not @bug.valid?
  end

  test 'title should be > 5' do
    @bug.title = 'a' * 4
    assert_not @bug.valid?
  end

  test 'title should be < 128' do
    @bug.title = 'a' * 129
    assert_not @bug.valid?
  end

  test 'content should be present' do
    @bug.content = '      '
    assert_not @bug.valid?
  end

  test 'content should be > 5' do
    @bug.content = 'a' * 4
    assert_not @bug.valid?
  end

  test 'content should be < 5000' do
    @bug.content = 'a' * 5001
    assert_not @bug.valid?
  end

  test 'bug_type should be present' do
    @bug.bug_type = '      '
    assert_not @bug.valid?
  end
end
