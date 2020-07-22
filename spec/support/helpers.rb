module Helpers
  module Login
    def log_in_as(account, password)
      post '/login', params: { account_number: account.account_number, password: password }
    end
  end
end
