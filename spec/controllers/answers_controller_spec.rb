require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  
  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question, user: user) }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers in question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requsted answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: answer } }

    it 'assigns the requsted answer to @answer' do 
      expect(assigns(:answer)).to eq answer
    end
    
    it 'renders show edit' do
      expect(response).to render_template :edit
    end 
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end     
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requsted answer to @answer' do 
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end
      it 'change answer attributtes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end
      it 'redirects to update answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end 

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }
      
      it 'does not change attributes' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DElETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    it 'delete answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to answers' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_answers_path(answer.question_id)
    end
  end
end
