class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, 
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  def author?(model)
    id == model.user_id
  end

  def voted?(model)
    votes.exists?(votable_id: model.id)
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.user_create(email, auth)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
    user.authorizations.create(provider: auth['provider'], uid: auth['uid'].to_s)
    user
  end
end
