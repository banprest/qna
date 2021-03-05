require 'rails_helper'

feature 'User can view list question', %q{
  In order to get answer from a community
  As an user
  I'd like to be able to view the questions
} do 

  given!(:questions) { create_list(:question, 3) }

  scenario 'User can view list questions' do
    visit questions_path

    expect(page).to have_content 'title1'
    expect(page).to have_content 'title2'
    expect(page).to have_content 'title3'
  end
end
