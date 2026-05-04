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

  # Fine Management
  resources :fines, only: [ :index, :show ] do
    member do
      post :mark_as_paid
    end
    collection do
      get :outstanding
      get :paid
    end
  end

  # Reports
  namespace :reports do
    root "dashboard#index"
    get "most_borrowed_books", to: "dashboard#most_borrowed_books"
    get "overdue_members", to: "dashboard#overdue_members"
    get "financial_summary", to: "dashboard#financial_summary"
    get "monthly_borrowing", to: "dashboard#monthly_borrowing"
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
  get "up" => "rails/health#show", as: :rails_health_check # why this route is needed? it is used for monitoring the health of the application. It provides a simple endpoint that can be pinged by monitoring tools to check if the application is running and responsive. This can help detect issues early and ensure that the application is available to users.
end

# what are the things that are unnecessary in the above code? i
