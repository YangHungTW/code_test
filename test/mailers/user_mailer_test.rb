require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    user = users(:yam)
    email = UserMailer.welcome(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['yanghungtw@notifications.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Welcome to my website!', email.subject
    assert_match(/Welcome!/, email.text_part.body.to_s)
  end

  test "password reset" do
    user = users(:yam)
    email = UserMailer.password_reset(user)

    assert_emails 1 do
      email.deliver_now
    end

    u = User.find_by(email: users(:yam).email)
    assert_equal ['yanghungtw@notifications.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Reset your password!', email.subject
    assert_match(/reset\?token=#{u.reset_password_token}/, email.text_part.body.to_s)
  end
end
