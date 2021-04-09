require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
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
  end

  describe 'cancel vote' do
    let!(:user1) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:vote) { create(:vote, user: user1, votable: question)} 

    it 'Destroy' do
      expect { question.cancel_vote(user1) }.to change(Vote, :count).by(-1)
    end
  end
end
