require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest

  test "should visit sign up page" do
    get sign_up_url

    assert_select "h1", text: "Sign Up"

    assert_response :success
  end

  test "should be signed up" do
    post create_user_url, params: {
      user: {
        email: "test@unittest.com",
        password: "justtest",
        password_confirmation: "justtest"
      }
    }

    assert_equal ["Welcome! You have signed up successfully."], flash[:notice]
    assert_redirected_to root_path
  end

  test "should visit edit page" do
    sign_in_as(users(:yam), "asdffdsa")
    get edit_user_url

    assert_select "h1", text: "Edit"

    assert_response :success
  end

  test "should update information" do
    user = users(:yam)
    sign_in_as(user, "asdffdsa")
    put update_user_url, params: {
      user: {
        name: user.name = "YangHung"
      }
    }

    assert_redirected_to root_path
    follow_redirect!
    assert_equal ["You updated your account successfully."], flash[:notice]
  end

  test "update failure" do
    user = users(:yam)
    sign_in_as(user, "asdffdsa")
    put update_user_url, params: {
      user: {
        name: user.name = "Yan"
      }
    }

    assert_not_nil user.errors.full_messages
    assert_response :success

    assert_select "h1", text: "Edit"
  end

end
