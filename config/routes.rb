Rails.application.routes.draw do
  resources :accounts
  get 'transactions', to: 'accounts#transactions'
end
