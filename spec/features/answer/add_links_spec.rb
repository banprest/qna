require 'rails_helper'

feature 'User can add links for answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:google_url) { 'https://www.google.ru/' }

  scenario 'User add link when ask answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'text text'

    fill_in 'Link_name', with: 'Google'
    fill_in 'link', with: google_url
    
    click_on 'Accept'
    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
    end
  end
end
