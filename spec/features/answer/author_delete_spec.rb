require 'rails_helper'

feature 'Author can delete answer', %q{
  In order to avoid mistakes
  As an author
  I'd like to be able to delete the answer
}do  
  
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Author delete question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted'
  end

  scenario 'Not author tried delete question' do
    sign_in(user1)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'You not author question'
  end
end
