require 'rails_helper'

feature 'Author can delete answer', %q{
  In order to avoid mistakes
  As an author
  I'd like to be able to delete the answer
}do  
  
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)

      within '.answer-new' do
        fill_in 'Body', with: 'text text' 
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Accept'
      end
    end

    scenario 'delete answer', js: true do
      within '.answers' do
        expect(page).to have_content 'text text'

        click_on 'Delete answer'

        expect(page).to have_no_content 'text text'
      end
    end

    scenario 'delete file with answer', js: true do
      expect(page).to have_link 'rails_helper.rb'

      click_on "Delete file"

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end
  
  describe 'Not Author' do
    given!(:answer) { create(:answer, user: user, question: question) }
    
    before do
      sign_in(user1)
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      visit question_path(question)
    end

    scenario 'tried delete answer' do
      expect(page).to have_content 'MyText'
      expect(page).to have_no_content 'Delete answer'
    end

    scenario 'tried delete file' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'Delete file'
    end
  end

  describe 'Unauthenticated' do
    given!(:answer) { create(:answer, user: user, question: question) }

    before do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      visit question_path(question)
    end

    scenario 'Unauthenticated user tried delete answer' do
      expect(page).to have_content 'MyText'
      expect(page).to have_no_content 'Delete answer'
    end


    scenario 'tried delete file' do
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to_not have_link 'Delete file'
    end
  end
end
