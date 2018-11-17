class PasswordsController < ApplicationController
  before_action :authenticated?
  before_action :verify_token, only: [:edit, :update]

  def edit
  end

  def update
    @user.assign_attributes(permit_params)

    if @user.save
      flash.now.notice = ["Your password was changed successfully."]
      flash.keep(:notice)
      redirect_to new_login_path and return
    else
      flash.now.alert = @user.errors.full_messages
      render "edit"
    end
  end

  def create
    @user = User.find_by(email: permit_params[:email])

    @user.send_password_reset_email if @user.present?

    flash.now.notice = ["You will receive an email with a link to reset your password."]
    flash.keep(:notice)
    redirect_to new_login_path
  end

  def new
  end

  private
    def permit_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def verify_token
      @user = User.find_by(reset_password_token: params[:token])

      if @user.nil? or  @user.reset_password_token_expired?
        flash.now.alert = ["Reset password link expired."]
        flash.keep(:alert)
        redirect_to new_login_path and return
      end
    end
end
