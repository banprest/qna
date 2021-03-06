require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  describe 'User author?' do
    let(:user1) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'User author question?' do
      expect(user.author?(question)).to eq true
    end

    it 'User not author question' do
      expect(user1.author?(question)).to eq false
    end

    it 'User author answer?' do
      expect(user.author?(answer)).to eq true
    end

    it 'User not author answer?' do
      expect(user1.author?(answer)).to eq false
    end
  end

end
