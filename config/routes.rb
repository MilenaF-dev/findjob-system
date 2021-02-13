Rails.application.routes.draw do
  root "home#index"

  resources :companies

  resources :vacancies, only: [:index, :show]
end
