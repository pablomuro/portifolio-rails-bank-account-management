require 'rails_helper'

RSpec.describe '/account', type: :request do
  let(:password) { FFaker::Internet.password(6, 16) }

  let(:logged_account) { create(:account, password: password, password_confirmation: password) }

  let(:valid_attributes) do
    attributes_for(:account, password: password, password_confirmation: password)
  end

  let(:invalid_attributes) do
    attributes_for(:invalid_account)
  end

  before do
    log_in_as(logged_account, password)
  end

  describe 'GET /accounts/menu' do
    it 'renders a successful response' do
      get '/accounts/menu/'
      expect(response).to be_successful
      expect(response).to render_template(:menu)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_account_path
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      account = Account.create! valid_attributes
      log_in_as(account, valid_attributes[:password])
      get edit_account_url(account)
      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Account' do
        expect do
          post accounts_url, params: { account: valid_attributes }
        end.to change(Account, :count).by(1)
      end

      it 'redirects to the menu' do
        post accounts_url, params: { account: valid_attributes }
        expect(response).to redirect_to('/accounts/menu')
        expect(flash[:notice]).to match('Account was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Account' do
        expect do
          post accounts_url, params: { account: invalid_attributes }
        end.to change(Account, :count).by(0)
      end

      it "display the 'new' template" do
        post accounts_url, params: { account: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        attributes_for(:update_account)
      end

      it 'updates the requested account' do
        attributes = new_attributes
        account = Account.create! valid_attributes
        log_in_as(account, valid_attributes[:password])
        patch account_url(account), params: { account: attributes }
        account.reload
        expect(account).to have_attributes(attributes)
      end

      it 'redirects to the menu' do
        account = Account.create! valid_attributes
        log_in_as(account, valid_attributes[:password])
        patch account_url(account), params: { account: new_attributes }
        expect(response).to redirect_to('/accounts/menu')
        expect(flash[:notice]).to match('Account was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it "display the 'edit' template" do
        account = Account.create! valid_attributes
        log_in_as(account, valid_attributes[:password])
        patch account_url(account), params: { account: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deactivate the requested account' do
      delete account_url(logged_account)
      logged_account.reload
      expect(logged_account.active).to be false
    end

    it 'redirects to the login page' do
      delete account_url(logged_account)
      expect(response).to redirect_to('/logout')
    end
  end

  describe 'GET /accounts/deposit' do
    it 'renders a successful response' do
      get '/accounts/deposit'
      expect(response).to be_successful
      expect(response).to render_template(:deposit)
    end
  end

  describe 'POST /accounts/deposit' do
    context 'with valid parameters' do
      it 'add money into the account' do
        amount = FFaker::Random.rand(100)
        previous_amount = logged_account.money_amount
        post '/accounts/deposit', params: { amount: amount }
        logged_account.reload
        expect(logged_account.money_amount).to be > previous_amount
      end
      it 'creates a new account transaction with type :deposit' do
        amount = FFaker::Random.rand(100)
        expect do
          post '/accounts/deposit', params: { amount: amount }
        end.to change(AccountTransaction, :count).by(1)
        last_transaction = AccountTransaction.last
        expect(last_transaction.deposit?).to be true
        expect(last_transaction.transaction_value).to eq(amount)
        expect(last_transaction.account_id).to eq(logged_account.id)
      end
    end

    context 'with invalid parameters' do
      it "raise error 'Invalid amount'" do
        amount = FFaker::Lorem.characters(6)
        post '/accounts/deposit', params: { amount: amount, commit: 'deposit' }
        logged_account.reload
        expect(response).to redirect_to '/accounts/deposit'
        expect(flash[:notice]).to match('Invalid amount.')
      end
    end
  end

  describe 'GET /accounts/withdraw' do
    it 'renders a successful response' do
      get '/accounts/withdraw'
      expect(response).to be_successful
      expect(response).to render_template(:withdraw)
    end
  end

  describe 'POST /accounts/withdraw' do
    context 'with valid parameters' do
      it 'remove money from logged account' do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        previous_amount = account.money_amount
        withdraw_amount = FFaker::Random.rand(999)
        log_in_as(account, password)
        post '/accounts/withdraw', params: { amount: withdraw_amount, password: password }
        account.reload
        expect(account.money_amount).to be < previous_amount
      end

      it 'creates a new account transaction with type :withdraw' do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        withdraw_amount = FFaker::Random.rand(999)
        log_in_as(account, password)
        expect do
          post '/accounts/withdraw', params: { amount: withdraw_amount, password: password }
        end.to change(AccountTransaction, :count).by(1)
        last_transaction = AccountTransaction.last
        expect(last_transaction.withdraw?).to be true
        expect(last_transaction.transaction_value).to eq(withdraw_amount)
        expect(last_transaction.account_id).to eq(account.id)
      end
    end

    context 'with invalid parameters' do
      it "raise error 'Invalid amount.' if amount is not a number'" do
        amount = FFaker::Lorem.characters(6)
        post '/accounts/withdraw', params: { amount: amount, commit: 'withdraw' }
        logged_account.reload
        expect(response).to redirect_to '/accounts/withdraw'
        expect(flash[:notice]).to match('Invalid amount.')
      end

      it "raise error 'Not enough money.' if account money amount is less than withdraw money'" do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        withdraw_amount = FFaker::Random.rand(999) + 1000.0
        log_in_as(account, password)
        post '/accounts/withdraw', params: { amount: withdraw_amount, password: password, commit: 'withdraw' }
        expect(response).to redirect_to '/accounts/withdraw'
        expect(flash[:notice]).to match('Not enough money.')
      end

      it "raise error 'Invalid password.' if password different from logged account password'" do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        withdraw_amount = FFaker::Random.rand(999) + 1000.0
        log_in_as(account, password)
        post '/accounts/withdraw', params: { amount: withdraw_amount, password: 'wrong_password', commit: 'withdraw' }
        expect(response).to redirect_to '/accounts/withdraw'
        expect(flash[:notice]).to match('Invalid password.')
      end
    end
  end

  describe 'GET /accounts/transfer' do
    it 'renders a successful response' do
      get '/accounts/transfer'
      expect(response).to be_successful
      expect(response).to render_template(:transfer)
    end
  end
  describe 'POST /accounts/transfer' do
    let(:receiver_account) { create(:account) }

    context 'with valid parameters' do
      it 'remove money from logged account and add in to the receiver account' do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        account_previous_amount = account.money_amount
        receiver_previous_amount = receiver_account.money_amount
        transfer_amount = FFaker::Random.rand(999)
        tax = transfer_tax(transfer_amount)
        log_in_as(account, password)
        post '/accounts/transfer', params: { amount: transfer_amount, account_number: receiver_account.account_number, password: password, commit: 'transfer' }
        account.reload
        receiver_account.reload
        expect(account.money_amount).to eq(account_previous_amount - transfer_amount - tax)
        expect(receiver_account.money_amount).to be == receiver_previous_amount + transfer_amount
      end

      it 'creates a new account transaction with type :outgoing_transfer' do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        transfer_amount = FFaker::Random.rand(999)
        tax = transfer_tax(transfer_amount)
        log_in_as(account, password)
        expect do
          post '/accounts/transfer', params: { amount: transfer_amount, account_number: receiver_account.account_number, password: password, commit: 'transfer' }
        end.to change(AccountTransaction, :count).by(2)

        outgoing_transaction = AccountTransaction.last
        expect(outgoing_transaction.outgoing_transfer?).to be true
        expect(outgoing_transaction.transaction_value).to eq(transfer_amount + tax)
        expect(outgoing_transaction.account_id).to eq(account.id)
      end

      it 'creates a new account transaction with type :incoming_transfer' do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        transfer_amount = FFaker::Random.rand(999)
        log_in_as(account, password)
        expect do
          post '/accounts/transfer', params: { amount: transfer_amount, account_number: receiver_account.account_number, password: password, commit: 'transfer' }
        end.to change(AccountTransaction, :count).by(2)

        incoming_transaction = AccountTransaction.order(date: :desc).where(account_id: receiver_account.id).take
        expect(incoming_transaction.incoming_transfer?).to be true
        expect(incoming_transaction.transaction_value).to eq(transfer_amount)
        expect(incoming_transaction.account_id).to eq(receiver_account.id)
      end

      it 'add tax to de transference' do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        account_previous_amount = account.money_amount
        transfer_amount = FFaker::Random.rand(999)
        tax = transfer_tax(transfer_amount)
        log_in_as(account, password)
        post '/accounts/transfer', params: { amount: transfer_amount, account_number: receiver_account.account_number, password: password, commit: 'transfer' }
        account.reload
        expect(tax).to be > 0
        expect(account.money_amount).to eq(account_previous_amount - transfer_amount - tax)
      end
    end

    context 'with invalid parameters' do
      it "raise error 'Invalid amount.' if amount is not a number'" do
        amount = FFaker::Lorem.characters(6)
        post '/accounts/transfer', params: { amount: amount, commit: 'transfer' }
        logged_account.reload
        expect(response).to redirect_to '/accounts/transfer'
        expect(flash[:notice]).to match('Invalid amount.')
      end

      it "raise error 'Not enough money.' if account money amount is less than withdraw money'" do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        transfer_amount = FFaker::Random.rand(999) + 1000.0
        log_in_as(account, password)
        post '/accounts/transfer', params: { amount: transfer_amount, account_number: receiver_account.account_number, password: password, commit: 'transfer' }
        expect(response).to redirect_to '/accounts/transfer'
        expect(flash[:notice]).to match('Not enough money.')
      end

      it "raise error 'Invalid password.' if password different from logged account password'" do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        transfer_amount = FFaker::Random.rand(999) + 1000.0
        log_in_as(account, password)
        post '/accounts/transfer', params: { amount: transfer_amount, account_number: receiver_account.account_number, password: 'wrong_password', commit: 'transfer' }
        expect(response).to redirect_to '/accounts/transfer'
        expect(flash[:notice]).to match('Invalid password.')
      end

      it "raise error 'Cannot transfer money to the same account.' if receiver account number is same as logged account'" do
        account = create(:account, money_amount: 1000.0, password: password, password_confirmation: password)
        transfer_amount = FFaker::Random.rand(999)
        log_in_as(account, password)
        post '/accounts/transfer', params: { amount: transfer_amount, account_number: account.account_number, password: password, commit: 'transfer' }
        expect(response).to redirect_to '/accounts/transfer'
        expect(flash[:notice]).to match('Cannot transfer money to the same account.')
      end
    end
  end

  describe 'GET /accounts/transactions' do
    it 'renders a successful response' do
      get '/accounts/transactions'
      expect(response).to be_successful
      expect(response).to render_template(:transactions)
    end
  end
end
