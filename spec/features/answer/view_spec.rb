require 'rails_helper'

feature 'User can view list answer', %q{
  In order to give an answer to the question
  As an authenticate user
  I'd like to be able to create the answer
} do 

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, :answers, question: question, user: user) }

  scenario 'User can view list questions' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
