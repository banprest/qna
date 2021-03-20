require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://www.google.ru/').for(:url) }

  describe 'Link gist?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, :gist, linkable: question)}
    let(:link1) { create(:link, linkable: question)}
    
    it 'true' do
      expect(link).to be_gist
    end

    it 'false' do
      expect(link1).to_not be_gist
    end
  end
end
