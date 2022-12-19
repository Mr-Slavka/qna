Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }

  root to: 'questions#index'

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

  resources :questions, concerns: %i[vote comment], shallow: true do
    resources :answers, concerns: %i[vote comment], except: [:index, :show, :edit] do
      post :mark_as_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => "/cable"

end
