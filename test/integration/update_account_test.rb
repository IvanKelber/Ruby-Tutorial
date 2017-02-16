require 'test_helper'

class UpdateAccountTest < ActionDispatch::IntegrationTest

  def setup
    @glick = users(:glick)
    @cj = users(:cj)
  end

  test "can't update information with invalid input" do
    log_in_as(@glick)
    get edit_user_path @glick
    assert_template "users/edit"
    patch user_path(@glick), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              current_password: "",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end

  test "update information with valid input" do
    log_in_as(@glick)

    get edit_user_path @glick
    assert_template "users/edit"
    new_name = "michael"
    new_email = "glick@gmail.com"
    new_password = ""
    patch user_path(@glick), params: { user: { name:  new_name,
                                              email: new_email,
                                              current_password: "password",
                                              password:              new_password,
                                              password_confirmation: new_password } }
    assert_redirected_to @glick
    @glick.reload
    assert_equal new_name, @glick.name
    assert_equal new_email, @glick.email
  end

  test "update information with friendly forwarding and valid input" do
    get edit_user_path @glick

    log_in_as(@glick)
    assert_redirected_to edit_user_path @glick
    new_name = "michael"
    new_email = "glick@gmail.com"
    new_password = ""
    patch user_path(@glick), params: { user: { name:  new_name,
                                              email: new_email,
                                              current_password: "password",
                                              password:              new_password,
                                              password_confirmation: new_password } }
    assert_redirected_to @glick
    @glick.reload
    assert_equal new_name, @glick.name
    assert_equal new_email, @glick.email
  end

  test "can't edit when not logged in" do
    get edit_user_path @glick
    assert_redirected_to login_path
    assert_not_empty flash
  end

  test "can't update when not logged in" do
    patch user_path(@glick), params: { user: { name: @glick.name,
                                              email: @glick.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "can't edit another user's account" do
    log_in_as(@glick)
    get edit_user_path @cj
    assert_redirected_to root_path
  end

  test "can't update another user's account" do
    log_in_as(@glick)
    patch user_path(@cj), params: { user: { name: @glick.name,
                                              email: @glick.email } }
    assert flash.empty?
    assert_redirected_to root_path
  end

end
