require 'rails_helper'

feature 'Author can delete question', %q{
  In order to avoid mistakes
  As an author
  I'd like to be able to delete the question
}do  
  
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Author delete question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question deleted'
  end

  scenario 'Not author tried delete question' do
    sign_in(user1)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'You not author question'
  end
end
