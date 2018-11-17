require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "valid email format" do
    user = User.new(
      email: "yanghungtw@unittest.com",
      password: "asdffdsa",
      password_confirmation: "asdffdsa"
    )
    user.valid?

    assert_empty user.errors.messages
  end

  test "invalid email format" do
    user = User.new(
      email: "yanghungtw.unittest.com",
      password: "asdffdsa",
      password_confirmation: "asdffdsa"
    )
    user.valid?

    assert_equal ["is invalid"], user.errors.messages[:email]
  end

  test "set name to email prefixing after create" do
    user = User.create(
      email: "yanghungtw@unittest.com",
      password: "asdffdsa",
      password_confirmation: "asdffdsa"
    )

    assert_equal "yanghungtw", user.name
  end

  test "invalid name length" do
    user = User.create(
      email: "yanghungtw@unittest.com",
      password: "asdffdsa",
      password_confirmation: "asdffdsa"
    )
    user.name = "yan"
    user.valid?

    assert_equal ["is too short (minimum is 5 characters)"], user.errors.messages[:name]
  end

  test "authenticate with wrong password" do
    user = User.authenticate(users(:yam).email, "asdfffdsa")

    assert_not user
  end

  test "sent welcome email after create" do
    user = nil
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      user = User.create(
        email: "yanghungtw@unittest.com",
        password: "asdffdsa",
        password_confirmation: "asdffdsa"
      )
    end

    welcome_email = ActionMailer::Base.deliveries.last

    assert_equal "Welcome to my website!", welcome_email.subject
    assert_equal user.email, welcome_email.to[0]
    assert_match(/And thanks for registration a new account at YangHungTW/, welcome_email.text_part.body.to_s)
  end

  test "expired reset password token" do
    assert users(:yang).reset_password_token_expired?
  end

  test "reset password token generator" do
    user = User.create(
      email: "yanghungtw@unittest.com",
      password: "asdffdsa",
      password_confirmation: "asdffdsa"
    )
    user.generate_reset_password_token
    assert_not_nil user.reset_password_token
    assert_not_nil user.reset_password_sent_at
  end
end
