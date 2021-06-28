require 'sphinx_helper'

feature 'User can search  ', %q{
  In order to find needed 
  As a User
  I'd like to be able to search 
} do

  given!(:user) { create(:user, email: 'title@mail.ru') }
  given!(:question) { create(:question,title: 'title question') }
  given!(:comment) { create(:comment, body: 'title comment') }
  given!(:answer) { create(:answer, body: 'title answer') }
 
  scenario 'User searches for the answer', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in id: 'query', with: answer.body
      choose(option: 'Answer')
      click_on 'Search'
      
      expect(page).to have_content answer.body
    end
  end

  scenario 'User searches for the all', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in id: 'query', with: 'title'
      choose(option: 'all')
      click_on 'Search'
      
      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end

  scenario 'User searches for the user', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in id: 'query', with: user.email
      choose(option: 'User')
      click_on 'Search'
      

      expect(page).to have_content user.email
    end
  end

  scenario 'User searches for the question', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in id: 'query', with: question.title
      choose(option: 'Question')
      click_on 'Search'
      
      expect(page).to have_content question.title
    end
  end

  scenario 'User searches for the comment', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      fill_in id: 'query', with: comment.body
      choose(option: 'Comment')
      click_on 'Search'
      

      expect(page).to have_content comment.body
    end
  end
end
