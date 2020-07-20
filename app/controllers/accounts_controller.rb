class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy, :make_deposit, :make_withdraw, :make_transfer, :transactions, :generate_transaction]
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_transaction_amount, only: [:make_deposit, :make_withdraw, :make_transfer]
  before_action :check_password, only: [:make_withdraw, :make_transfer]
  before_action :check_funds, only: [:make_withdraw, :make_transfer]
  before_action :check_receiver, only: [:make_transfer]

  def dashboard; end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.active = true
    respond_to do |format|
      if @account.save
        set_account_session(@account.id)
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /accounts/1/edit
  def edit; end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.active = false
    @account.save
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully deactivated.' }
      format.json { head :no_content }
    end
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

  def transaction_params
    params.permit(:amount, :account_number, :password, :start_date, :end_date, :commit)
  end

  def check_password
    redirect_to session_params[:commit], notice: 'Invalid password' unless @account.authenticate(session_params[:password])
  end

  def check_receiver
    @receiver_account = Account.find_by(account_number: transaction_params[:account_number])
    redirect_to :transfer, notice: 'Invalid receiver account number' if @receiver_account.nil?
  end

  def check_funds(amount)
    redirect_to session_params[:commit], notice: 'Not enough money' unless (@account.money_amount - amount >= 0.0)
  end

  def transfer_tax
    now = DateTime.new
    tax = now.on_weekday? && now.hour >= 9 && now.hour <= 18 ? 5.0 : 7.0

    tax += @transaction_amount > 1000.0 ? 10.0 : 0.0

    return tax
  end

  def generate_transaction(transaction_type, account)
    account = account || @account

    transaction = AccountTransaction.new
    transaction.account_id = account.id
    transaction.date = Time.current
    transaction.transaction_value = transaction_type != AccountTransaction.outgoing_transfer ? @transaction_amount : @transaction_amount + transfer_tax
    transaction.account_money_amount = account.money_amount
    transaction.transaction_type = transaction_type
    transaction.save
  end
end
