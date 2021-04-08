require 'rails_helper'

feature 'User can add badge for question', %q{
  In order to reward user for the best answer
  As an question's author
  I'd to be able to reward user
} do
  given(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'title title'
    fill_in 'Body', with: 'text text'
  end
  
  scenario 'User add bage when ask question' do
    fill_in 'Reward', with: 'reward'
    fill_in 'Image', with: 'https://image.flaticon.com/icons/png/128/1579/1579492.png'

    click_on 'Ask'

    expect(page).to have_content 'reward'
  end
end
