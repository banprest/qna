require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe 'GET #new' do 
    before { get :new}

    it 'assigns a new User to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end
    it 'renders show new' do 
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }
    before { session[:auth] = oauth_data }
    
    it 'saves a new user in the database' do 
      expect { post :create, params: { user: { email: 'test1@mail.com' } } }.to change(User, :count).by(1)
    end

    it 'saves a new authenticate in the database' do
      expect { post :create, params: { user: { email: 'test1@mail.com' } } }.to change(Authorization, :count).by(1)
    end
  end
end
