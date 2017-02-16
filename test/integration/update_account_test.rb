require 'test_helper'

class UpdateAccountTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:glick)
  end

  test "update information with invalid input" do
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              current_password: "",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
  end

  test "update information with valid input" do
    get edit_user_path @user
    assert_template "users/edit"
    new_name = "michael"
    new_email = "glick@gmail.com"
    new_password = ""
    patch user_path(@user), params: { user: { name:  new_name,
                                              email: new_email,
                                              current_password: "password",
                                              password:              new_password,
                                              password_confirmation: new_password } }

    # puts "====="
    # puts @user.password_digest == User.digest("password")
    # puts "======"
    assert_redirected_to @user
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end

end
