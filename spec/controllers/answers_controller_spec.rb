require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    it_behaves_like 'POST create' do
      let(:params) { { question_id: question, answer: attributes_for(:answer),format: :js } }
      let(:object) { Answer }
      let(:template) { :create }
      let(:invalid_params) { { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }
    end

    context 'with valid attributes' do
      it 'renders to create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer),format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    it_behaves_like 'PATCH update' do
      let(:object) { answer }
      let(:params) { { id: answer, answer: object_value, format: :js } }
      let(:value) { [:body] }
      let(:invalid_params) { { id: answer, answer: attributes_for(:answer, :invalid), format: :js } }
      let(:object_value) { { body: 'new body'  } }
      let(:template) { :update }
    end
  end

  describe 'PATCH #best' do

    let(:user1) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    
    context 'Author mark answer' do
      before { login(user) }

      it 'mark answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best).to eq true
      end

      it 'render best' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'Not author tred mark answer' do
      before { login(user1) }

      it 'tried mark answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best).to eq false
      end
    end
  end

  describe 'DELETE #destroy' do

    let(:user1) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'DELETE destroy' do
      let(:params) { { id: answer, format: :js } }
      let(:object) { answer.class }
      let(:redirect_path_author) { render_template :destroy }
      let(:redirect_path_not_author) { render_template :destroy }
      let(:redirect_path_unauth) {  be_unauthorized }
    end
  end

  describe 'POST #vote up' do
    it_behaves_like 'POST vote_up' do
      let(:params) { { id: answer } }
    end
  end

  describe 'POST #vote down' do
    it_behaves_like 'POST vote_up' do
      let(:params) { { id: answer } }
    end
  end

  describe 'POST #cancel vote' do

    it_behaves_like 'POST cancel_vote' do
      let!(:vote) { create(:vote, user: user1, votable: answer)}
      let(:params) { { id: answer } }
    end
  end
end
