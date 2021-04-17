Rails.application.routes.draw do
  devise_for :users

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

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
