class UserMailer < ApplicationMailer
  default from: 'yanghungtw@notifications.com'

  def welcome user
    mail(to: user.email, subject: 'Welcome to my website!')
  end

  def password_reset user
    @token = user.generate_reset_password_token

    mail(to: user.email, subject: 'Reset your password!')
  end
end
