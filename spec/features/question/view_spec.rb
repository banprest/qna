require 'rails_helper'

feature 'User can view list question', %q{
  In order to get answer from a community
  As an user
  I'd like to be able to view the questions
} do 

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, :questions, user: user) }

  scenario 'User can view list questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
