class RegistrationsController < ApplicationController
  before_action :authenticated?, only: [:create]
  before_action :authenticate_user!, only: [:edit, :update]

  def edit
  end

  def update
    current_user.assign_attributes(permit_params)

    if current_user.save
      flash.now.notice = ["You updated your account successfully."]
      flash.keep(:notice)
      redirect_to root_path and return
    else
      flash.now.alert = current_user.errors.full_messages
      render "edit"
    end
  end

  def create
    @user = User.new(permit_params)

    if @user.save
      flash.now.notice = ["Welcome! You have signed up successfully."]
      flash.keep(:notice)
      signed_in! @user
      redirect_to root_path
    else
      flash.now.alert = @user.errors.full_messages
      render "new"
    end
  end

  def new
    @user = User.new
  end

  private
    def permit_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end

end
