class Account < ApplicationRecord
  has_secure_password

  validates :active, presence: true
  validates :account_number, presence: true, length: { is: 6 }, format: { with: /[0-9]{4}-[0-9]{1}/, message: 'account number format must be XXXX-X' }, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create, length: { in: 6..16 }
  validates :password_confirmation, presence: true, on: :create
  validates :money_amount, presence: true, numericality: { greater_than: 0.0}
end
