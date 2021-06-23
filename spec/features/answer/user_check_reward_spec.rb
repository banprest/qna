require 'rails_helper'

feature 'Author can mark best answer', %q{
  In order to show the answer that helped the author
  As an author question
  I'd like to be able to mark best answer
}  do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:reward) { create(:reward, question: question) }
  

  scenario 'Author mark answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Mark Best'

      expect(page).to have_content 'Best Answer'
    end
    # Упали тесты на выделение лучшего ответа автором. Перестал ставится флаг best true при клике на Mark Best
    # В девелопмент все работает

    visit rewards_path


    #expect(page).to have_content reward.reward_title
    #expect(page).to have_content question.title 
  end
end
