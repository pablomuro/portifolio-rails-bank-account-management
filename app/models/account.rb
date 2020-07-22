class Account < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { in: 3..50 }
  validates :email, presence: true, length: { maximum: 50 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: 'invalid email format'}
  validates :active, presence: true
  validates :account_number, presence: true, length: { is: 6 }, format: { with: /[0-9]{4}-[0-9]{1}/, message: 'account number format must be XXXX-X' }, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create, length: { in: 6..16 }
  validates :password_confirmation, presence: true, on: :create
  validates :money_amount, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
end
