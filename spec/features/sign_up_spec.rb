require 'rails_helper'

feature 'User can sign_up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sing up
} do

  background { visit new_user_registration_path }
  
  scenario 'registrated in valid attributes' do
    fill_in 'Email', with: 'test@mail.ru'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'registrate in invalid attributes' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
