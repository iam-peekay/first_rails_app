require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit to user" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {
                              name: "",
                              email: "foo@invalid",
                              password: "foo",
                              password_confirmation: "bar"
                            }
    assert_template 'users/edit'
  end

  test "successful edit to user" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: {
                              name: name,
                              email: email,
                              password: "",
                              password_confirmation: ""
                            }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end


    test "successful edit with friendly forwarding" do
      get edit_user_path(@user)
      log_in_as(@user)
      assert_redirected_to edit_user_path(@user)
      name = "Foo Bar"
      email = "foo@bar.com"
      patch user_path(@user), user: {
                                name: name,
                                email: email,
                                password: "",
                                password_confirmation: ""
                              }
      assert_not flash.empty?
      assert_redirected_to @user
      @user.reload
      assert_equal name, @user.name
      assert_equal email, @user.email
      get login_path
      assert_template 'sessions/new'
      post login_path, session: { email: @user.email, password: 'password' }
      assert is_logged_in?
      assert_redirected_to @user
      assert_nil session[:forwarding_url]
    end
end
