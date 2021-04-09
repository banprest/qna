Rails.application.routes.draw do
  devise_for :users

  resources :rewards, only: :index
  resources :links, only: :destroy
  resources :attachments, only: :destroy
  resources :questions do
    member do
      post :vote_up
      post :vote_down
      post :cancel_vote
    end
    resources :answers, shallow: true do
      member do
        patch :best
      end
    end
  end

  root to: 'questions#index'
end
