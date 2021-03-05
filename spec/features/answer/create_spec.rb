require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer to the question
  As an authenticate user
  I'd like to be able to create the answer
}do
  given(:user) { create(:user) } 
  given!(:question) { create(:question, user: user) }

  describe do

    background do
      sign_in(user)
    end

    scenario 'create answer' do
      visit question_path(question)
      fill_in 'Body', with: 'text text' 
      click_on 'Accept'

      expect(page).to have_content 'You answer succesfuly created'
      expect(page).to have_content 'text text'
    end

    scenario 'create answer with ivalid attributes' do
      visit question_path(question)
      click_on 'Accept'

      expect(page).to have_content "Body can't be blank"
    end

  end

  scenario 'Unauthenticated user tried create answer' do
    visit question_path(question)
    click_on 'Accept'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
