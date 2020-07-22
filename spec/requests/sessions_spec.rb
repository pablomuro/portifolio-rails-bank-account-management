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
      get '/login'
      expect(response).to be_successful
      expect(response).to render_template('sessions/login')
    end
  end
  describe 'POST /login' do
    context 'with valid params' do
      it "redirects to 'accounts/menu'" do
        post '/login', params: valid_params
        expect(response).to redirect_to('/accounts/menu')
      end
    end
    context 'with invalid params' do
      it "redirects to 'login/'" do
        post '/login', params: invalid_params
        expect(response).to render_template('sessions/login')
      end
    end
  end
  describe 'GET /logout' do
    it 'has to destroy_account_session' do
      get '/logout'
      expect(response).to redirect_to '/login'
    end
  end
end
