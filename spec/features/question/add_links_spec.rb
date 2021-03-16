require 'rails_helper'

feature 'User can add links for question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd to be able to add links
} do
  given(:user) { create(:user) }
  given(:google_url) { 'https://www.google.ru/' }

  scenario 'User add link when ask question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'title title'
    fill_in 'Body', with: 'text text'

    fill_in 'Link_name', with: 'Google'
    fill_in 'link', with: google_url
    
    click_on 'Ask'

    expect(page).to have_link 'Google', href: google_url
  end
end
