require 'rails_helper'

feature 'User can edit links for answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd to be able to edit links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer)}

  describe 'Author' do
    given(:google_url) { 'https://www.google.ru/' }

    background do
      sign_in(user)
      visit question_path(question)
    end 

    scenario 'edit link when update question', js:true do
      within '.answers' do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link_name', with: 'Google'
        fill_in 'link', with: google_url
        
        click_on 'Save'
      end
      
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'tried edit invalid link when update answer', js:true do
      within '.answers' do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link_name', with: 'Google'
        fill_in 'link', with: 'google_url'
        
        click_on 'Save'
      end
   
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
