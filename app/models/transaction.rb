class Transaction
  include ActiveModel::Model
  include ActiveModel::Validations
  attr_accessor :account_number, :mount, :password

  validates :account_number, presence: true, length: { is: 6 }, format: { with: /[0-9]{4}-[0-9]{1}/, message: 'account number format must be XXXX-X' }
  validates :mount, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :password, presence: true, confirmation: true, length: { in: 6..16 }
end
