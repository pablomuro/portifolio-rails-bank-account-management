json.extract! account, :id, :active, :account_number, :money_amount, :created_at, :updated_at
json.url account_url(account, format: :json)
