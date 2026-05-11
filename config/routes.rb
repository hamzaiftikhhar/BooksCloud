Rails.application.routes.draw do
  devise_for :users
require "sidekiq/web"

mount Sidekiq::Web => "/sidekiq"
  root "dashboard#index"

  # Book Management
  resources :books do
    collection do
      get :search # /books/search
      get :search_authors # /books/search_authors when on the books show page
    end
  end

  # Author Management
  resources :authors

  # Member Management
  resources :members do
    member do
      patch :suspend
      patch :reactivate
    end
    resources :borrowing_history, only: [ :index ] # why it is /borrowings and not members/borrowings
  end

  # Borrowing Management
  resources :borrowings, only: [ :index, :show, :create ] do
    member do
      post :return_book
      patch :return_book
    end
    collection do
      get :active
      get :overdue
      get :search_member
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
    root "dashboard#index" # reports dashboard
    get "most_borrowed_books", to: "dashboard#most_borrowed_books"
    get "overdue_members", to: "dashboard#overdue_members"
    get "financial_summary", to: "dashboard#financial_summary"
    get "monthly_borrowing", to: "dashboard#monthly_borrowing"
  end

  # Admin Panel
  namespace :admin do
    root "dashboard#index" # users dashboard
    resources :users, only: [ :index, :show, :create, :destroy ] do
      member do
        patch :change_role
      end
    end
  end
  # # config/routes.rb

  # resources :borrowings do
  #   collection do
  #     get :search_member  # This creates search_member_borrowings_path
  #   end

  #   member do
  #     patch :return_book
  #   end
  # end


  # Health check
  get "up" => "rails/health#show", as: :rails_health_check # why this route is needed? it is used for monitoring the health of the application. It provides a simple endpoint that can be pinged by monitoring tools to check if the application is running and responsive. This can help detect issues early and ensure that the application is available to users.
end

# what are the things that are unnecessary in the above code? i
