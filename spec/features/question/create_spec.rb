require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticate user
  I'd like to be able to ask the question
}do 
  
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'title title'
      fill_in 'Body', with: 'text text'
      click_on 'Ask'

      expect(page).to have_content 'You question successfuly created.'
      expect(page).to have_content 'title title'
      expect(page).to have_content 'text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
