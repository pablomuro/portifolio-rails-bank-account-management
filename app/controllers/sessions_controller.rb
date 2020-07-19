class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:login, :create_session]

  def login; end

  def logout; end

  def create_session
    account = Account.find_by(account_number: session_params[:account_number])
    if account&.authenticate(session_params[:password])
      set_account_session(account.id)
      redirect_to '/account/dashboard'
    end
  end

  private

  def session_params
    params.permit(:account_number, :password)
  end
end
