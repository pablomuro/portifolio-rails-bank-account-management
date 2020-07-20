class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy, :make_deposit, :make_withdraw, :make_transfer, :transactions, :generate_transaction]
  skip_before_action :require_login, only: [:new, :create]
  before_action :check_password, only: [:make_withdraw, :make_transfer]
  before_action :check_funds, only: [:make_withdraw, :make_transfer]
  before_action :check_receiver, only: [:make_transfer]

  # TODO - Calcular tarifas
  def dashboard
  end

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
    amount = transaction_params[:amount]
    @account.money_amount += amount
    generate_transaction(AccountTransaction.deposit, amount) if @account.save
  end

  def withdraw; end

  def make_withdraw
    amount = transaction_params[:amount]
    @account.money_amount -= amount
    generate_transaction(AccountTransaction.withdraw, amount) if @account.save
  end

  def transfer; end

  def make_transfer
    amount = transaction_params[:amount]
    @account.money_amount -= amount
    @receiver_account.money_amount += amount

    generate_transaction(AccountTransaction.incoming_transfer, amount,receiver_account)
    generate_transaction(AccountTransaction.outgoing_transfer, amount)
  end

  def transactions
    @transactions_list = AccountTransaction.where(account_id: @account.id)
  end

  private

  def set_account
    @account = logged_account
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

  def generate_transaction(transaction_type, amount, account)
    account = account || @account

    transaction = AccountTransaction.new
    transaction.account_id = account.id
    transaction.date = new Date
    transaction.transaction_value = amount
    transaction.account_money_amount = account.money_amount
    transaction.transaction_type = transaction_type
    transaction.save
  end
end
