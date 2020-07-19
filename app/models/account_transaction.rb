class AccountTransaction < ApplicationRecord
  belongs_to :account
  enum transaction_type: [ :deposit, :withdraw, :incoming_transfer :outgoing_transfer ]
end
