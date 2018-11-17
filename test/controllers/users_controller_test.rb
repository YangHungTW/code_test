require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
   test "no login will redirect to login page" do
     get root_url

     assert_equal ["You need to sign in or sign up before continuing."], flash[:alert]

     assert_redirected_to new_login_path
   end

   test "show user info if logged in" do
     sign_in_as(users(:yam), "asdffdsa")

     assert_select "h1", text: "Your Information"
   end

end
