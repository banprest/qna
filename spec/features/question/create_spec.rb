require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticate user
  I'd like to be able to ask the question
}do 
  given(:user) { create(:user) }

  describe 'Authenticated user' do
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

    scenario 'asks a questiona with attached files' do
      fill_in 'Title', with: 'title title'
      fill_in 'Body', with: 'text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multiply session', js: true do
    scenario 'questio apears on another user page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'title title'
        fill_in 'Body', with: 'text text'
        click_on 'Ask'

        expect(page).to have_content 'You question successfuly created.'
        expect(page).to have_content 'title title'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'title title'
      end
    end
  end

  scenario 'Unauthenticated user tries asks a question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end
