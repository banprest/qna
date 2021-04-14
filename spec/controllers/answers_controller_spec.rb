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
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer),format: :js } }.to change(question.answers, :count).by(1)
      end
      it 'renders to create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer),format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end     
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'change answer attributtes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end
      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end 

    context 'with invalid attributes' do      
      it 'does not change attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 're-renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
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

      it 'render best' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end
  end

  describe 'DELETE #destroy' do

    let(:user1) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author delete answer' do
      before { login(user) }
      
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author tried delete answer' do
      before { login(user1) }

      it 'tried delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Question, :count)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Unauthenticated user tried delete question' do
      
      it ' tried delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Question, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #vote up' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'create vote +1' do
        expect { post :vote_up, params: { id: answer } }.to change(Vote, :count).by(1)
      end
    end
    
    describe 'Author' do
      it 'author tried create vote + 1' do
        login(user)
        expect { post :vote_up, params: { id: answer } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #vote down' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'create vote -1' do
        expect { post :vote_down, params: { id: answer } }.to change(Vote, :count).by(1)
      end
    end
    describe 'Author' do
      it 'author tried create vote  -1' do
        login(user)
        expect { post :vote_down, params: { id: answer } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #cancel vote' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      let!(:vote) { create(:vote, user: user1, votable: answer)}
      before { login(user1) }

      it 'cancel vote' do
        expect { post :cancel_vote, params: { id: answer } }.to change(Vote, :count).by(-1)
      end
    end

    describe 'Author' do
      let(:user1) { create(:user) }
      let!(:vote) { create(:vote, user: user1, votable: answer)}
      before { login(user) }

      it 'Author tried cancel vote' do
        expect { post :cancel_vote, params: { id: answer } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #create_comment' do
    describe 'Authenticate user' do
      before { login(user) }
      it 'valid parameters' do
        expect { post :create_comment, params: { id: answer, comment: attributes_for(:comment) }, format: :js }.to change(answer.comments, :count).by(1) 
      end

      it 'not valid parameters' do
        expect { post :create_comment, params: { id: answer, comment: { body: ""} }, format: :js }.to_not change(answer.comments, :count) 
      end

      it 'render create_comment.js' do
        post :create_comment, params: { id: answer, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template 'comments/_create_comment'
      end
    end

    describe 'Not authenticate user' do
      it 'tried create user' do
        expect { post :create_comment, params: { id: answer, comment: attributes_for(:comment) } }.to_not change(answer.comments, :count)
      end 
    end
  end
end
