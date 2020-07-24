Rails.application.routes.draw do
  resources :accounts, only: [:new, :edit, :create, :update, :destroy]
  scope '/accounts' do
    get '/', to: 'accounts#menu'
    get '/menu', to: 'accounts#menu', as: :menu
    get 'deposit', to: 'accounts#deposit', as: :deposit
    post 'deposit', to: 'accounts#make_deposit', as: :make_deposit
    get 'withdraw', to: 'accounts#withdraw', as: :withdraw
    post 'withdraw', to: 'accounts#make_withdraw', as: :make_withdraw
    get 'transfer', to: 'accounts#transfer', as: :transfer
    post 'transfer', to: 'accounts#make_transfer', as: :make_transfer
    get 'transactions', to: 'accounts#transactions', as: :transactions
  end

  get 'login', to: 'sessions#login', as: :login
  post 'login', to: 'sessions#create_session'
  get 'logout', to: 'sessions#logout', as: :logout
  get '/', to: 'sessions#login'
end
