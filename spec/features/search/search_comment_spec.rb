require 'rails_helper'

feature 'User can search for comment', %q{
  In order to find needed comment
  As a User
  I'd like to be able to search for the comment
} do

  given!(:comment) { create(:comment) }
 
  scenario 'User searches for the comment', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search for:', with: comment.body
      choose(option: 'Comment')
      click_on 'Search'
      

      expect(page).to have_content comment.body
    end
  end
end
