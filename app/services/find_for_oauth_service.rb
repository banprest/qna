class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.user_create(email, auth)
      user.skip_confirmation!
      user.save!
    end  
    user
  end
end
