require 'rails_helper'

RSpec.describe AccountsController, type: :routing do
  describe 'routing without authenticate' do
    it 'routes to #login' do
      expect(get: '/account/dashboard').to route_to('sessions#login')
      expect(get: '/account/edit').to route_to('sessions#login')
      expect(put: '/account').to route_to('sessions#login')
      expect(patch: '/account').to route_to('sessions#login')
      expect(delete: '/account').to route_to('sessions#login')
    end
  end
  describe 'routing' do
    it 'routes to #dashboard' do
      expect(get: '/account').to route_to('accounts#index')
    end

    it 'routes to #new' do
      expect(get: '/account/new').to route_to('accounts#new')
    end

    it 'routes to #edit' do
      expect(get: '/account/edit').to route_to('accounts#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/account').to route_to('accounts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/account').to route_to('accounts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/account').to route_to('accounts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/account').to route_to('accounts#destroy', id: '1')
    end
  end
end
