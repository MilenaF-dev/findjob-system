Rails.application.routes.draw do
  root "home#index"

  devise_for :users

  resources :companies

  resources :vacancies, only: [:index, :show, :new, :create]
end
