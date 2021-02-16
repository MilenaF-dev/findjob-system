Rails.application.routes.draw do
  root "home#index"

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :companies

  resources :vacancies, only: [:index, :show, :new, :create]
end
