Rails.application.routes.draw do

  concern :vote do
    member do
      patch :vote_up
      patch :vote_down
      delete :unvote
    end
  end

  root to: 'questions#index'
  devise_for :users

  resources :questions, concerns: :vote, shallow: true do
    resources :answers, concerns: :vote, except: [:index, :show, :edit] do
      post :mark_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
