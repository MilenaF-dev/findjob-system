Rails.application.routes.draw do
  root "home#index"

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :companies, only: [:index, :show, :edit, :update]

  resources :vacancies, only: [:index, :show, :new, :create]
end
