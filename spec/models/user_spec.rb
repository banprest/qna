require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:subscriptions) }
  it do
    should have_many(:sub_questions).
      through(:subscriptions).
      source(:question)
  end
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }


  describe '#author?' do
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

  describe '#voted?' do
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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
