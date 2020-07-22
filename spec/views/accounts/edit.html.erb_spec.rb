require 'rails_helper'

RSpec.describe 'accounts/edit', type: :view do
  before(:each) do
    @account = create(:account)
  end

  it 'renders the edit account form' do
    pending
    # render

    # assert_select 'form[action=?][method=?]', account_path(@account), 'post' do
    # end
  end
end
