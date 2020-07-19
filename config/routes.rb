Rails.application.routes.draw do
  resources :accounts
  get 'transactions', to: 'accounts#transactions'
  get 'login', to: 'sessions#login'
  post 'login', to: 'sessions#create_session'
  get 'dashboard', to: 'accounts#dashboard'
  get '/', to: 'sessions#login'

  # TODO: - testar essa rota depois
  # resources :accounts do
  #   get 'transactions', to: 'accounts#transactions'
  # end
end
