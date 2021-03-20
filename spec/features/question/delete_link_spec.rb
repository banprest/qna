require 'rails_helper'

feature 'Author can delete link for question', %q{
  In order to avoid mistakes
  As an author
  I'd like to be able to delete link for question
}do
  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question)}

  describe 'Author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'delete link' do
      expect(page).to have_link 'GitHub', href: 'https://github.com/'
      click_on 'Delete link'
      expect(page).to_not have_link 'GitHub'
    end 
  end

  scenario 'Not author tried delte link' do
    sign_in(user1)
    visit question_path(question)

    expect(page).to have_link 'GitHub', href: 'https://github.com/'
    expect(page).to_not have_content 'Delete link'
  end

  scenario 'Not aunthenticated user tried delete link' do
    visit question_path(question)

    expect(page).to have_link 'GitHub', href: 'https://github.com/'
    expect(page).to_not have_content 'Delete link'
  end
end

