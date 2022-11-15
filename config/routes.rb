Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, except: [:index, :show, :edit]
  end

end
