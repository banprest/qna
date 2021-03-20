require 'rails_helper'

feature 'Author can mark best answer', %q{
  In order to show the answer that helped the author
  As an author question
  I'd like to be able to mark best answer
}  do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create(:answer, question: question, user: user) }
  given!(:reward) { create(:reward, question: question) }
  

  scenario 'Author mark answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Mark Best'

    visit rewards_path

    expect(page).to have_content "MyString"
    expect(page).to have_content question.title 
  end
end
