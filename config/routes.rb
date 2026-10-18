Rails.application.routes.draw do
  devise_for :users

  root to: "pages#landing"
  get "dashboard", to: "courts#index", as: "dashboard"

  resources :courts, only: [ :index, :show ]
  resources :reservations, only: [ :index, :new, :create, :show, :destroy ] do
    collection do
      get :weekly
    end
  end

  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
end
