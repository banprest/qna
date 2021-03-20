require 'rails_helper'

feature 'User can edit links for question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd to be able to edit links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question)}

  describe 'Author' do
    given(:google_url) { 'https://www.google.ru/' }

    background do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
    end 

    scenario 'edit link when ask question', js:true do
      within '.question' do
        click_on 'add link'
        fill_in 'Link_name', with: 'Google'
        fill_in 'link', with: google_url
        
        click_on 'Save'
      end
      
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'tried edit invalid link when ask question', js:true do
      within '.question' do
        click_on 'add link'
        fill_in 'Link_name', with: 'Google'
        fill_in 'link', with: 'google_url'
        
        click_on 'Save'
      end
   
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
