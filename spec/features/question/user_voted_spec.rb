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

    scenario 'tried voted again', js: true do 
      sign_in(user1)
      visit question_path(question)

      click_on 'Voted +1'

      expect(page).to_not have_content 'Voted +1'
      expect(page).to_not have_content 'Voted -1'
      expect(page).to have_content 'Cancel vote'
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
    scenario 'tried voted' do
      visit question_path(question)

      expect(page).to_not have_content 'Voted +1'
      expect(page).to_not have_content 'Voted -1'
      expect(page).to_not have_content 'Cancel vote'
    end
  end

  describe 'Author' do
    scenario 'tried voted' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_content 'Voted +1'
      expect(page).to_not have_content 'Voted -1'
      expect(page).to_not have_content 'Cancel vote'
    end
  end
end
