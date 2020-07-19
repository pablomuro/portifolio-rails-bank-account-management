json.extract! account_transaction, :id, :date, :transaction_type, :transaction_value, :account_money_amount, :account_id, :created_at, :updated_at
json.url account_transaction_url(account_transaction, format: :json)
