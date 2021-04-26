class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    elsif request.env['omniauth.auth'][:email].blank?
      session[:auth] = request.env['omniauth.auth']
      redirect_to user_get_email_path, alert: 'Fill Mail'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
