module OmniauthHelpers
  OmniAuth.config.test_mode = true

  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123456',
      'info' => {
        'email' => 'user@mail.ru',
      },
      'credentials' => {
        'app_id' => 'mock_tocken',
        'app_secret' => 'mock_secret'
      }
    })
  end

  def mock_auth_hash_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '123456',
      'info' => {
      },
      'credentials' => {
        'app_id' => 'mock_tocken',
        'app_secret' => 'mock_secret'
      }
    })
  end
end
