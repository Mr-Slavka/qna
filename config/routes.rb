Rails.application.routes.draw do

  concern :vote do
    member do
      patch :vote_up
      patch :vote_down
      delete :unvote
    end
  end

  concern :comment do
    resources :comments, only: :create
  end

  root to: "questions#index"
  devise_for :users

  resources :questions, concerns: %i[vote comment], shallow: true do
    resources :answers, concerns: %i[vote comment], except: [:index, :show, :edit] do
      post :mark_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => "/cable"

end
