require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:password) { FFaker::Internet.password(6, 16) }

  let(:account) { create(:account, password: password, password_confirmation: password) }

  let(:valid_params) do
    { account_number: account.account_number, password: password }
  end

  let(:invalid_params) do
    { account_number: account.account_number + 'as', password: password + 'as' }
  end

  describe 'GET /login' do
    it "render the 'login' template" do
      get login_url
      expect(response).to be_successful
      expect(response).to render_template :login
    end
    it 'redirect to menu if account is logged in' do
      log_in_as(account, password)
      get login_url
      expect(response).to redirect_to menu_url
    end
  end
  describe 'POST /login' do
    context 'with valid params' do
      it "redirects to 'accounts/menu'" do
        post login_url, params: valid_params
        expect(response).to redirect_to menu_url
      end
    end
    context 'with invalid params' do
      it "redirects to 'login/'" do
        post login_url, params: invalid_params
        expect(response).to redirect_to login_url
      end
    end
  end
  describe 'GET /logout' do
    it 'has to destroy_account_session' do
      get logout_url
      expect(response).to redirect_to login_url
    end
  end
end
