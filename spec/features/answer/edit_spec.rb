require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  
  given(:user1) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    describe 'Author' do

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'edits his answer' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your Answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your Answer', with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end

      scenario 'edits his answer with files' do
        within '.answers' do
          click_on 'Edit'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user1)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
