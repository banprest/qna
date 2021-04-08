Rails.application.routes.draw do
  devise_for :users

  resources :rewards, only: :index
  resources :links, only: :destroy
  resources :attachments, only: :destroy
  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :best
      end
    end
  end

  root to: 'questions#index'
end
