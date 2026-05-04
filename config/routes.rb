Rails.application.routes.draw do
  devise_for :users

  root "dashboard#index"

  # Book Management
  resources :books do
    collection do
      get :search
    end
  end

  # Member Management
  resources :members do
    member do
      patch :suspend
      patch :reactivate
    end
    resources :borrowing_history, only: [ :index ]
  end

  # Borrowing Management
  resources :borrowings, only: [ :index, :show, :create ] do
    member do
      post :return_book
    end
    collection do
      get :active
      get :overdue
    end
  end



  # Admin Panel
  namespace :admin do
    root "dashboard#index"
    resources :users, only: [ :index, :show, :create, :destroy ] do
      member do
        patch :change_role
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end

# what are the things that are unnecessary in the above code? i
