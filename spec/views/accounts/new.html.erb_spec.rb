require 'rails_helper'

RSpec.describe 'accounts/new', type: :view do
  before(:each) do
    assign(:account, Account.new())
  end

  it 'renders new account form' do
    pending
    # render

    # assert_select 'form[action=?][method=?]', account_path, 'post' do
    # end
  end
end
