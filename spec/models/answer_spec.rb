require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Mark best answer' do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user1) }
    let!(:reward) { create(:reward, question: question) }

    describe 'mark best' do
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

      describe 'check reward' do
        it 'user have reward' do
          answer1.mark_as_best
          expect(user.rewards.first).to eq nil
        end

        it 'user not have reward' do
          answer.mark_as_best
          expect(user.rewards.first).to eq reward
        end
      end
    end
  end

  describe 'add_answer' do
    let(:answer) { build(:answer) }

    it 'calls AddAnswerMailJob' do
      expect(AddAnswerMailJob).to receive(:perform_later)
      answer.save!
    end
  end
end
