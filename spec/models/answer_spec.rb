require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe 'Mark best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user)}

    it 'mark answer1 and check him' do
      answer1.mark_as_best
      answer1.reload
      expect(answer1.best).to eq true
    end

    it 'mark answer1 and check answer' do
      answer1.mark_as_best
      answer.reload
      expect(answer.best).to eq false
    end

    it 'mark answer1 and mark answer check answer' do
      answer1.mark_as_best
      answer.mark_as_best
      answer.reload
      expect(answer.best).to eq true
    end

    it 'mark answer1 and mark answer check answer1' do
      answer1.mark_as_best
      answer.mark_as_best
      answer1.reload
      expect(answer1.best).to eq false
    end
  end
end
