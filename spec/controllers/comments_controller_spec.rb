require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    describe 'Authenticate user' do
      before { login(user) }

      describe 'question' do

        it_behaves_like 'POST create' do
          let(:params) { { question_id: question, comment: attributes_for(:comment), format: :js } }
          let(:object) { question.comments }
          let(:template) { :create }
          let(:invalid_params) { { question_id: question, comment: { body: ""}, format: :js } }
        end

        it 'render create_comment.js' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end

      describe 'answer' do

        it_behaves_like 'POST create' do
          let(:params) { { answer_id: answer, comment: attributes_for(:comment), format: :js } }
          let(:object) { answer.comments }
          let(:template) { :create }
          let(:invalid_params) { { answer_id: answer, comment: { body: ""}, format: :js } }
        end

        it 'render create_comment.js' do
          post :create, params: { answer_id: answer, comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'Not authenticate user' do
      it 'tried create user' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to_not change(question.comments, :count)
      end 
    end
  end
end
