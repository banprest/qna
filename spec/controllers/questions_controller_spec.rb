require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 3, question: question, user: user) }

    before { get :show, params: { id: question } }


    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'assigns the requsted question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new @answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do 
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do 
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question to @link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Question to @reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders show new' do 
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do 
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assigns the requsted question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show edit' do 
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do 
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do 
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'    
      end

      it 'redirects to update question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
      
      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-rendre edit update' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do

    let(:user1) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context 'Author delete question' do
      before { login(user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
      it 'redirect_to questions_path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author tried delete question' do
      before { login(user1) }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
      it 'redirect_to show' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'Unauthenticated user tried delete question' do
      
      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #vote up' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'create vote +1' do
        expect { post :vote_up, params: { id: question } }.to change(Vote, :count).by(1)
      end
    end
    
    describe 'Author' do
      it 'author tried create vote + 1' do
        login(user)
        expect { post :vote_up, params: { id: question } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #vote down' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'create vote -1' do
        expect { post :vote_down, params: { id: question } }.to change(Vote, :count).by(1)
      end
    end
    describe 'Author' do
      it 'author tried create vote  -1' do
        login(user)
        expect { post :vote_down, params: { id: question } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #cancel vote' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      let!(:vote) { create(:vote, user: user1, votable: question)}
      before { login(user1) }

      it 'cancel vote' do
        expect { post :cancel_vote, params: { id: question } }.to change(Vote, :count).by(-1)
      end
    end

    describe 'Author' do
      let(:user1) { create(:user) }
      let!(:vote) { create(:vote, user: user1, votable: question)}
      before { login(user) }

      it 'Author tried cancel vote' do
        expect { post :cancel_vote, params: { id: question } }.to_not change(Vote, :count)
      end
    end
  end
end
