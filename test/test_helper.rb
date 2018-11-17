ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module SignInHelper
  def sign_in_as(user, password)
    post new_login_path, params: {
      session: {
        email: user.email,
        password: password
      }
    }

    assert_redirected_to root_path
    follow_redirect!
    assert_equal ["Welcome #{user.name}! Signed in successfully."], flash[:notice]
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end
