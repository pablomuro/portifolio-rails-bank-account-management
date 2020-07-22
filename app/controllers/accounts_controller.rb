class AccountsController < ApplicationController
  before_action :set_account, only: %i[edit update destroy make_deposit make_withdraw make_transfer transactions generate_transaction]
  skip_before_action :require_login, only: %i[new create]
  before_action :set_transaction_amount, only: %i[make_deposit make_withdraw make_transfer]
  before_action :check_password, only: %i[make_withdraw make_transfer]
  before_action :check_funds, only: %i[make_withdraw make_transfer]
  before_action :check_receiver, only: [:make_transfer]

  def menu; end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.active = true
    if @account.save
      set_account_session(@account.id)
      redirect_to '/accounts/menu', notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to '/accounts/menu', notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @account.update_attribute(:active, false)
    redirect_to '/logout'
  end

  def deposit; end

  def make_deposit
    @account.money_amount += @transaction_amount
    generate_transaction(AccountTransaction.deposit) if @account.save
  end

  def withdraw; end

  def make_withdraw
    @account.money_amount -= @transaction_amount
    generate_transaction(AccountTransaction.withdraw) if @account.save
  end

  def transfer; end

  def make_transfer
    @account.money_amount -= @transaction_amount + transfer_tax
    @receiver_account.money_amount += @transaction_amount
    generate_transaction(AccountTransaction.incoming_transfer, receiver_account)
    generate_transaction(AccountTransaction.outgoing_transfer)
  end

  def transactions
    @transactions_list = AccountTransaction.where(account_id: @account.id)
  end

  private

  def set_account
    @account = logged_account
  end

  def set_transaction_amount
    @transaction_amount = transaction_params[:amount]
  end

  def account_params
    params.require(:account).permit(:active, :account_number, :password, :password_confirmation, :money_amount)
  end

  def update_params
    params.require(:account).permit(:name, :email)
  end

  def transaction_params
    params.permit(:amount, :account_number, :password, :start_date, :end_date, :commit)
  end

  def check_password
    unless @account.authenticate(session_params[:password])
      redirect_to session_params[:commit], notice: 'Invalid password'
    end
  end

  def check_receiver
    @receiver_account = Account.find_by(account_number: transaction_params[:account_number])
    redirect_to :transfer, notice: 'Invalid receiver account number' if @receiver_account.nil?
  end

  def check_funds(amount)
    redirect_to session_params[:commit], notice: 'Not enough money' unless @account.money_amount - amount >= 0.0
  end

  def transfer_tax
    now = DateTime.new
    tax = now.on_weekday? && now.hour >= 9 && now.hour <= 18 ? 5.0 : 7.0

    tax += @transaction_amount > 1000.0 ? 10.0 : 0.0

    tax
  end

  def generate_transaction(transaction_type, account)
    account ||= @account

    transaction = AccountTransaction.new
    transaction.account_id = account.id
    transaction.date = Time.current
    transaction.transaction_value = transaction_type != AccountTransaction.outgoing_transfer ? @transaction_amount : @transaction_amount + transfer_tax
    transaction.account_money_amount = account.money_amount
    transaction.transaction_type = transaction_type
    transaction.save
  end
end
