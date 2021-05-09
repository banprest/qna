Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  
  get '/user/get_email', to: 'users#new'
  post '/user/set_email', to: 'users#create'
  resources :rewards, only: :index
  resources :links, only: :destroy
  resources :attachments, only: :destroy
  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :cancel_vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :comments, only: [:create], shallow: true
    resources :answers, concerns: [:votable], shallow: true do     
      resources :comments, only: [:create], shallow: true
      member do
        patch :best
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :questions, only: [:index]
      resources :profiles, only: [] do
        get :me, on: :collection
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
