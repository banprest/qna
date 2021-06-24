require 'rails_helper'

feature 'User can search for all', %q{
  In order to find needed all
  As a User
  I'd like to be able to search for the all
} do

  given!(:user) { create(:user, email: 'title@mail.ru') }
  given!(:question) { create(:question,title: 'title question') }
  given!(:comment) { create(:comment, body: 'title comment') }
  given!(:answer) { create(:answer, body: 'title answer') }
 
  scenario 'User searches for the all', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search for:', with: ''
      choose(option: 'all')
      click_on 'Search'
      
      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end
end
