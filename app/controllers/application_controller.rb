class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  private
    def authenticate_user!
      if !signed_in?
        flash.now.alert = ["You need to sign in or sign up before continuing."]
        flash.keep(:alert)
        redirect_to new_login_path and return
      end
    end

    def authenticated?
      if signed_in?
        flash.now.notice = ["You are already signed in."]
        redirect_to root_path
      end
    end

    def signed_in?
      session[:user_id].present?
    end

    def signed_in! user
      session[:user_id] = user.id
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end
