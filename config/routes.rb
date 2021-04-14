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
  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do     
      member do
        patch :best
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
