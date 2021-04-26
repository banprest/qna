require 'rails_helper'

feature 'User can sign_in with omniauth', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sing up with omniauth
} do


  describe "access top page" do
    scenario "can sign in user with GitHub account" do
      visit new_user_session_path
      mock_auth_hash_github
      click_link "Sign in with GitHub"
      
      expect(page).to have_content("Successfully authenticated from GitHub account.")
      expect(page).to have_content("Log out")
    end

    scenario 'can sign in user with Vkontakte account' do
      visit new_user_session_path
      mock_auth_hash_vkontakte
      click_link "Sign in with Vkontakte"

      expect(page).to have_content 'Fill Mail'

      fill_in 'Email', with: 'test@mail.ru'
      click_on 'Save'

      expect(page).to have_content 'Confirm email'

      open_email('test@mail.ru')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'

      visit new_user_session_path
      click_link "Sign in with Vkontakte"

      expect(page).to have_content("Successfully authenticated from Vkontakte account.")
      expect(page).to have_content("Log out")
    end

    scenario "can handle authentication error" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_session_path
      click_link "Sign in with GitHub"
      
      expect(page).to have_content("Could not authenticate you from GitHub because \"Invalid credentials\".")
    end
  end
end
