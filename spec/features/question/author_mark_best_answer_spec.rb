require 'rails_helper'

feature 'Author can mark best answer', %q{
  In order to show the answer that helped the author
  As an author question
  I'd like to be able to mark best answer
}  do

  given(:user1) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, :answers, question: question, user: user) }
  

  scenario 'Author mark answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on('Mark Best', match: :first)

      expect(page).to have_content 'Best Answer'
    end
  end
  scenario 'Not author tried mark answer' do
    sign_in(user1)
    visit question_path(question)

    expect(page).to_not have_content 'Mark Best'
  end
  scenario 'Unautheanticated user tried mark answer' do 
    visit question_path(question)

    expect(page).to_not have_content 'Mark Best'
  end
end
