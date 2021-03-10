require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'Mark best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'mark answer' do
      answer1 = Answer.create(body: 'body', best: false, question_id: question.id, user_id: user.id )
      answer1.mark_as_best
      expect(answer.best).to eq false
      expect(answer1.best).to eq true
      answer.mark_as_best
      answer.reload
      answer1.reload
      expect(answer.best).to eq true
      expect(answer1.best).to eq false
    end
  end
end
