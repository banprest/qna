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

    it_behaves_like 'POST create' do
      let(:params) { { question: attributes_for(:question) } }
      let(:object) { Question }
      let(:template) { :new }
      let(:invalid_params) { { question: attributes_for(:question, :invalid) } }
    end

    it 'create subscribe subscribe' do
      expect { post :create, params: { question: attributes_for(:question) } }.to change(Subscription, :count).by(1)
    end

    context 'with valid attributes' do
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    it_behaves_like 'PATCH update' do
      let(:object) { question }
      let(:params) { { id: question, question: object_value, format: :js } }
      let(:value) { [:title, :body] }
      let(:invalid_params) { { id: question, question: attributes_for(:question, :invalid), format: :js } }
      let(:object_value) { { title: 'new title',  body: 'new body'  } }
      let(:template) { :update }
    end
  end

  describe 'DELETE #destroy' do

    let(:user1) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'DELETE destroy' do
      let(:params) { { id: question } }
      let(:object) { question.class }
      let(:redirect_path_author) { redirect_to questions_path }
      let(:redirect_path_not_author) { redirect_to root_path }
      let(:redirect_path_unauth) { redirect_to new_user_session_path }
    end
  end

  describe 'POST #vote up' do

    it_behaves_like 'POST vote_up' do
      let(:params) { { id: question } }
    end
  end

  describe 'POST #vote down' do

    it_behaves_like 'POST vote_up' do
      let(:params) { { id: question } }
    end
  end

  describe 'POST #cancel vote' do

    it_behaves_like 'POST cancel_vote' do
      let!(:vote) { create(:vote, user: user1, votable: question)}
      let(:params) { { id: question } }
    end
  end
end
