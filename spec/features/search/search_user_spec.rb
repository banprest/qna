require 'rails_helper'

feature 'User can search for user', %q{
  In order to find needed user
  As a User
  I'd like to be able to search for the user
} do

  given!(:user) { create(:user, email: 'user@mail.ru') }
 
  scenario 'User searches for the user', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search for:', with: user.email
      choose(option: 'User')
      click_on 'Search'
      

      expect(page).to have_content user.email
    end
  end
end
