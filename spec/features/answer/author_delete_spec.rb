require 'rails_helper'

feature 'Author can delete answer', %q{
  In order to avoid mistakes
  As an author
  I'd like to be able to delete the answer
}do  
  
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  scenario 'Author delete answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'text text' 
    click_on 'Accept'

    expect(page).to have_content 'You answer succesfuly created'
    expect(page).to have_content 'text text'

    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted'
    expect(page).to have_no_content 'text text'
  end
  describe do
    given!(:answer) { create(:answer, user: user, question: question) }
    
    scenario 'Not author tried delete answer' do
      sign_in(user1)
      visit question_path(question)

      expect(page).to have_content 'MyText'
      expect(page).to have_no_content 'Delete answer'
    end

    scenario 'Unauthenticated user tried delete answer' do
      visit question_path(question)

      expect(page).to have_content 'MyText'
      expect(page).to have_no_content 'Delete answer'
    end
  end
end
