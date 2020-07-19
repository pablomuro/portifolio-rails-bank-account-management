class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :logged_in?
  helper_method :logged_account
  helper_method :set_account_session
  helper_method :destroy_account_session

  def logged_account
    Account.find_by(id: session[:account_id])
  end

  def logged_in?
    !logged_account.nil?
  end

  def require_login
    redirect_to '/login' unless logged_in?
  end

  def set_account_session(account_id)
    session[:account_id] = account_id
  end

  def destroy_account_session
    session[:account_id] = nil
  end
end
