require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer to the question
  As an authenticate user
  I'd like to be able to create the answer
}do
  given(:user) { create(:user) } 
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
    end

    scenario 'create answer' do
      visit question_path(question)
      fill_in 'Body', with: 'text text' 
      click_on 'Accept'

      within '.answers' do
        expect(page).to have_content 'text text'
      end
    end

    scenario 'create answer with ivalid attributes' do
      visit question_path(question)
      click_on 'Accept'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create answer with attached files' do
      visit question_path(question)
      fill_in 'Body', with: 'text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Accept'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multiply session', js: true do
    scenario 'answer apears on another user page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'text text' 
        click_on 'Accept'

        within '.answers' do
          expect(page).to have_content 'text text'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'text text'
        end
      end
    end
  end


  scenario 'Unauthenticated user tried create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Accept'
  end

end
