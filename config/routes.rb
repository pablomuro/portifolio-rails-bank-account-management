Rails.application.routes.draw do
  resources :accounts, only: [:new, :edit, :create, :update, :destroy]
  scope '/accounts' do
    get '/menu', to: 'accounts#menu'
    get 'deposit', to: 'accounts#deposit'
    post 'deposit', to: 'accounts#make_deposit'
    get 'withdraw', to: 'accounts#withdraw'
    post 'withdraw', to: 'accounts#make_withdraw'
    get 'transfer', to: 'accounts#transfer'
    post 'transfer', to: 'accounts#make_transfer'
    get 'transactions', to: 'accounts#transactions'
  end

  get 'login', to: 'sessions#login'
  post 'login', to: 'sessions#create_session'
  get 'logout', to: 'sessions#logout'
  get '/', to: 'sessions#login'
end
