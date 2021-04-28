class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    create_oauth('GitHub')
  end

  def vkontakte
    create_oauth('Vkontakte')
  end

  private 

  def create_oauth(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    auth = request.env['omniauth.auth']
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif auth[:info][:email].blank?
      session[:auth] = request.env['omniauth.auth']
      redirect_to user_get_email_path, alert: 'Fill Mail'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
