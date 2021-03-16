require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  
  given(:user1) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    describe 'Author' do
      
      background do
        sign_in(user)
        visit question_path(question)

        click_on 'Edit'
      end 
      
      scenario 'edits his question' do
        within '.question' do
          fill_in 'Your Title', with: 'edited title'
          fill_in 'Your Question', with: 'edited question'
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question with files' do
        within '.question' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edits his question with errors' do
        within '.question' do
          fill_in 'Your Title', with: ''
          fill_in 'Your Question', with: ''
          click_on 'Save'

          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user1)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
