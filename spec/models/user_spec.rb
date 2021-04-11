require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }


  describe 'User author?' do
    let(:user1) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'User author question?' do
      expect(user).to be_author(question)
    end

    it 'User not author question' do
      expect(user1).to_not be_author(question)
    end

    it 'User author answer?' do
      expect(user).to be_author(answer)
    end

    it 'User not author answer?' do
      expect(user1).to_not be_author(answer)
    end
  end

  describe 'User voted?' do
    let(:user2) { create(:user) }
    let(:user1) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:vote) { create(:vote, user: user1, votable: question)}

    it  'User voted' do
      expect(user1).to be_voted(question)
    end

    it 'User not voted' do
      expect(user2).to_not be be_voted(question)
    end
  end
end
