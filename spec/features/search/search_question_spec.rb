require 'rails_helper'

feature 'User can search for question', %q{
  In order to find needed question
  As a User
  I'd like to be able to search for the question
} do

  given!(:question) { create(:question) }

  scenario 'User searches for the question', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in 'Search for:', with: question.title
      choose(option: 'Question')
      click_on 'Search'
      
      expect(page).to have_content question.title
    end
  end
end
