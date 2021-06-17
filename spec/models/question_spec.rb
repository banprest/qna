require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:subscriptions) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body } 

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'rating' do
    let(:user1) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:vote) { create(:vote, user: user1, votable: question)} 

    it 'show rating' do
      expect(question.rating).to eq 1
    end
  end

  describe 'vote' do
    let(:user1) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'vote' do
      expect { question.vote(user1, 1) }.to change(Vote, :count).by(1)
    end

    it 'vote eq +1' do
      question.vote(user1, 1)
      expect(question.votes[0].value).to eq 1
    end
  end

  describe 'cancel vote' do
    let!(:user1) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:vote) { create(:vote, user: user1, votable: question)} 

    it 'Destroy' do
      expect { question.cancel_vote(user1) }.to change(Vote, :count).by(-1)
    end

    it 'Destroy check object' do
      question.cancel_vote(user1)
      expect(question.votes[0]).to eq nil
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:other_user1) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:subscription_true) { create(:subscription, user: user, question: question) }
    let!(:subscription_false) { create(:subscription, user: other_user, question: question, notification: false) }

    it 'user was subscribe notification true' do
      expect(question).to be_subscribed(user)
    end

    it 'user was subskribe notification false' do
      expect(question).to_not be_subscribed(other_user)
    end

    it 'user was not subskribe' do
      expect(question).to_not be_subscribed(other_user1)
    end
  end
end
