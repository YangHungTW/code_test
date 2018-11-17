require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should create session" do
    sign_in_as(users(:yam), "asdffdsa")
  end

  test "failed create session" do
    post new_login_path, params: {
      session: {
        email: users(:yam).email,
        password: "asdffffff"
      }
    }

    assert_response :success
    assert_equal ["Invalid email or password."], flash[:alert]
    assert_select "h1", text: "Login"
  end

  test "should visit login page" do
    get login_url
    assert_response :success
    assert_select "h1", text: "Login"
  end

  test "should destroy session" do
    sign_in_as(users(:yam), "asdffdsa")
    delete logout_url
    assert_redirected_to new_login_path
    follow_redirect!
    assert_equal ["Signed out successfully."], flash[:notice]
    assert_select "h1", text: "Login"
  end

end
