require 'rails_helper'

feature 'User can rate question', %q{
  In order to mark best question
  As an user
  I'd like to be rate question
} do 
  given(:user1) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  
  describe 'Authenticated user' do
    scenario 'voted +1', js: true do
      sign_in(user1)
      visit question_path(question)

      click_on 'Voted +1'

      expect(page).to have_content 'Rating: 1'
    end

    scenario 'voted -1', js: true do
      sign_in(user1)
      visit question_path(question)

      click_on 'Voted -1'

      expect(page).to have_content 'Rating: -1'
    end

    scenario 'cancel vote', js: true do
      sign_in(user1)
      visit question_path(question)

      click_on 'Voted +1'
      click_on 'Cancel vote'

      expect(page).to have_content 'Rating: 0'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tried voted'
  end

  describe 'Author' do
    scenario 'tried voted'
  end
end
