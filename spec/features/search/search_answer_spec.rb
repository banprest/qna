require 'rails_helper'

feature 'User can search for answer', %q{
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
} do

  given!(:answer) { create(:answer) }
 
  scenario 'User searches for the answer', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search for:', with: answer.body
      choose(option: 'Answer')
      click_on 'Search'
      
      expect(page).to have_content answer.body
    end
  end
end
