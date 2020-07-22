class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:login, :create_session]

  def login
    redirect_to '/accounts/menu' if logged_in?
  end

  def logout
    destroy_account_session
    redirect_to '/login'
  end

  def create_session
    account = Account.find_by(account_number: session_params[:account_number])
    if account&.authenticate(session_params[:password])
      set_account_session(account.id)
      redirect_to '/accounts/menu'
    else
      render :login, notice: 'Account number or password invalid'
    end
  end

  private

  def session_params
    params.permit(:account_number, :password)
  end
end
