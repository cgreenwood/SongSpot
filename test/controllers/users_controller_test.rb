require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get users_show_
    assert_response :success
  end

end
