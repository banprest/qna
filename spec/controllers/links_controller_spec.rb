require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:user1) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:link) { create(:link, linkable: answer) }
  let!(:link1) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do

    context 'Author delete answer link' do
      before { login(user) }
      
      it 'delete file' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(answer.links, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author delete question link' do
      before { login(user) }
      
      it 'delete file' do
        expect { delete :destroy, params: { id: link1 }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: link1 }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author delete question file' do
      before { login(user1) }
      
      it 'tried delete file' do        
        expect { delete :destroy, params: { id: link1 }, format: :js }.to_not change(question.links, :count)
      end

      it 'render destroy' do
        delete :destroy, params: { id: link1 }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author tried delete answer file' do
      before { login(user1) }
      
      it 'tried delete file' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(answer.links, :count)
      end

      it 'render destroy' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
