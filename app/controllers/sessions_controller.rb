class SessionsController < ApplicationController
  before_action :authenticated?, only: [:new, :create]
  before_action :authenticate_user!, only: [:destroy]

  def create
    if @user = User.authenticate(permit_params[:email], permit_params[:password])
      signed_in! @user
      flash.now.notice = ["Welcome #{@user.name}! Signed in successfully."]
      flash.keep(:notice)
      redirect_to root_path and return
    else
      flash.now.alert = ["Invalid email or password."]
      render "new"
    end
  end

  def new
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    flash.now.notice = ["Signed out successfully."]
    flash.keep(:notice)
    redirect_to new_login_path
  end

  private
    def permit_params
      params.require(:session).permit(:email, :password)
    end

end
