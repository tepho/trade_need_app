Rails.application.routes.draw do
  resources :transactions
  resources :users
  get 'extract/:id', to: 'users#extract_by_date'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
