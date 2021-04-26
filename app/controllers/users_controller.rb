class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    password = Devise.friendly_token[0, 20]
    @user = User.create!(email: email_params[:email], password: password, password_confirmation: password)
    @user.authorizations.create(provider: session[:auth]['provider'], uid: session[:auth]['uid'].to_s)
    redirect_to root_path, alert: 'Confirm email'
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
