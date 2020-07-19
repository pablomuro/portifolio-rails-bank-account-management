class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :destroy, :make_deposit, :make_withdraw, :make_transfer, :transactions]
  skip_before_action :require_login, only: [:new, :create]

  def dashboard; end

  # GET /accounts/new
  def newmake_transfer
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit; end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
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

  def deposit
  end

  def make_deposit
    amount = transaction_params.amount
  end

  def withdraw; end

  def make_withdraw
    amount = transaction_params.amount
  end

  def transfer; end

  def make_transfer
    amount = transaction_params.amount
  end

  def transactions
    transactions_list = AccountTransaction.where(account_id: @account.id)
    # TODO- redirect to transactionUrl
    # respond_to do |format|
    #   format.html { render: transactions_list, notice: 'Account was successfully destroyed.' }
    #   format.json { render json: transactions_list }
    # end
    respond_to do |format|
      format.json { render json: transactions_list}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = logged_account
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:active, :account_number, :password, :password_confirmation, :money_amount)
  end

  def transaction_params
    params.permit(:amount, :account_number)
  end
end
