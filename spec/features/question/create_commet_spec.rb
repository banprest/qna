require 'rails_helper'

feature 'User can create commet', %q{
  In order to get commet from a community
  As an authenticate user
  I'd like to be able to create commet
}do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  it 'Authenticate user create commet', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-comments' do
      click_on 'Create comment'
      fill_in 'Comment', with: '123'
      click_on 'Save'

      expect(page).to have_content user.email
      expect(page).to have_content '123'
    end
  end

  describe 'multiply session', js: true do
    scenario 'questio apears on another user page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-comments' do
          click_on 'Create comment'
          fill_in 'Comment', with: '123'
          click_on 'Save'

          expect(page).to have_content user.email
          expect(page).to have_content '123'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content user.email
        expect(page).to have_content '123'
      end
    end
  end

  it 'Not authenticate user tried create comment' do
    visit question_path(question)

    expect(page).to_not have_content 'Create comment'
  end
end 
