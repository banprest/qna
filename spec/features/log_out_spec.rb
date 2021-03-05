require 'rails_helper'

feature 'User can log_out', %q{
  In order to comlete session
  As an authenticated user
  I'd like to be able to log_out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user log out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Log_out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
