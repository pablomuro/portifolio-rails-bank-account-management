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

  describe 'GET /deposit' do
    it '' do
    end
  end
  describe 'POST /deposit' do
    it '' do
    end
  end

  describe 'GET /withdraw' do
    it '' do
    end
  end
  describe 'POST /withdraw' do
    it '' do
    end
  end

  describe 'GET /transfer' do
    it '' do
    end
  end
  describe 'POST /transfer' do
    it '' do
    end
  end

  describe 'GET /transactions' do
    it '' do
    end
  end
end
