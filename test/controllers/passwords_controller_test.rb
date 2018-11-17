require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "should get forgot password page" do
    get new_forgot_password_path
    assert_response :success
    assert_select "h1", text: "Forgot Your Password?"
  end

  test "should send forgot password email" do
    user = users(:yang)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post forgot_password_path, params: { user: { email: user.email } }
    end
    reset_password_email = ActionMailer::Base.deliveries.last
    u = User.find_by(email: user.email)

    assert_equal "Reset your password!", reset_password_email.subject
    assert_equal user.email, reset_password_email.to[0]
    assert_match(/reset\?token=#{u.reset_password_token}/, reset_password_email.text_part.body.to_s)

    assert_equal ["You will receive an email with a link to reset your password."], flash[:notice]
    assert_redirected_to new_login_path
  end

  test "should visit reset password page with valid token" do
    user = User.find_by(email: users(:yam).email)
    user.generate_reset_password_token
    get reset_password_url(token: user.reset_password_token)
    assert_response :success
    assert_select "h1", text: "Change your password"
  end

  test "should not visit reset password page with expired token" do
    get reset_password_url(token: users(:yang).reset_password_token)

    assert_redirected_to new_login_path
    assert_equal ["Reset password link expired."], flash[:alert]

    follow_redirect!
    assert_select "h1", text: "Login"
  end

  test "should update password" do
    user = User.find_by(email: users(:yam).email)
    user.generate_reset_password_token

    put update_password_path(token: user.reset_password_token), params: {
      user: {
        password: "qwerrewq",
        password_confirmation: "qwerrewq"
      }
    }

    assert_redirected_to new_login_path

    follow_redirect!
    assert_equal ["Your password was changed successfully."], flash[:notice]
    assert_select "h1", text: "Login"
  end

  test "should not update with invalid password" do
    user = User.find_by(email: users(:yam).email)
    user.generate_reset_password_token
    put update_password_path(token: user.reset_password_token), params: {
      user: {
        password: "qwerrew",
        password_confirmation: "qwerrrrr"
      }
    }

    assert_not_nil user.errors[:password_confirmation], ["doesn't match Password"]

    assert_response :success
    assert_select "h1", text: "Change your password"
  end

end
