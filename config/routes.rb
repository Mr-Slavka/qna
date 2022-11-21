Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, except: [:index, :show, :edit] do
      post :mark_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
end
