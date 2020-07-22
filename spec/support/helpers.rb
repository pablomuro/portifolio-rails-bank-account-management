module Helpers
  module Login
    def log_in_as(account, password)
      post '/login', params: { account_number: account.account_number, password: password }
    end
  end

  def transfer_tax(amount)
    now = DateTime.new
    tax = now.on_weekday? && now.hour >= 9 && now.hour <= 18 ? 5.0 : 7.0

    tax += amount > 1000.0 ? 10.0 : 0.0

    tax
  end
end
