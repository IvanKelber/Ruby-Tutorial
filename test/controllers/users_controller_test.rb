require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @glick = users(:glick)
    @cj = users(:cj)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

end
