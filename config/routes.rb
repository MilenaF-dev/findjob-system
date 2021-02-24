Rails.application.routes.draw do
  root "home#index"

  get "search", to: "home#search"

  devise_for :users, path: "users", controllers: { :registrations => "users/registrations" }

  devise_for :candidates, path: "candidates", controllers: { :registrations => "candidates/registrations" }
  resources :candidates, only: [:show]

  resources :companies, only: [:index, :show, :edit, :update]

  resources :vacancies, only: [:index, :show, :new, :create, :edit, :update] do
    post "disable", on: :member
    post "enable", on: :member

    resources :job_applications, only: [:create], shallow: true do
      resources :feedbacks, only: [:index, :new, :create], shallow: true do
        resources :answer, only: [:index, :new, :create]
      end
    end
  end

  resources :job_applications, only: [:index]
end
