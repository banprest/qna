require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    it 'was not subscribe' do
      expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:subscription) { create(:subscription, user: user, question: question) }
    
    it 'was subscribe' do
      expect { delete :destroy, params: { question_id: question.id, id: subscription.id } }.to change(Subscription, :count).by(-1)
    end
  end
end
