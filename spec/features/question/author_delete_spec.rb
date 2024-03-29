require 'rails_helper'

feature 'Author can delete question', %q{
  In order to avoid mistakes
  As an author
  I'd like to be able to delete the question
}do  
  
  given(:user) { create(:user) }
  given(:user1) { create(:user) }

  describe 'Author' do

    before do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'title title'
      fill_in 'Body', with: 'text text'
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Ask'
    end

    scenario 'delete question' do
      expect(page).to have_content 'You question successfuly created.'
      expect(page).to have_content 'title title'
      expect(page).to have_content 'text text'

      click_on 'Delete question'

      expect(page).to have_content 'Question deleted'
      expect(page).to have_content 'Ask question'
      expect(page).to have_no_content 'title title'
      expect(page).to have_no_content 'text text'
    end

    scenario 'delete file with question' do
      expect(page).to have_link 'rails_helper.rb'
      click_on "Delete file"

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  describe do
    given!(:question) { create(:question, user: user) }
    
    scenario 'Not author tried delete question' do
      sign_in(user1)
      visit question_path(question)

      expect(page).to have_content 'MyText'
      expect(page).to have_content 'MyString'
      expect(page).to have_no_content 'Delete question'
    end

    scenario 'Unauthenticated user tried delete question' do
      visit question_path(question)

      expect(page).to have_content 'MyText'
      expect(page).to have_content 'MyString'
      expect(page).to have_no_content 'Delete question'
    end
  end
end
