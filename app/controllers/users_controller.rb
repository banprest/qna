class UsersController < ApplicationController
  
  skip_authorization_check
  
  def new
    @user = User.new
  end

  def create
    @user = User.user_create(email_params[:email], session[:auth])
    redirect_to root_path, alert: 'Confirm email'
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
