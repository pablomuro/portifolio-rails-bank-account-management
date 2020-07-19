class CreateAccountTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :account_transactions do |t|
      t.datetime :date
      t.integer :transaction_type
      t.decimal :transaction_value, precision: 10, scale: 2
      t.decimal :account_money_amount, precision: 10, scale: 2
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
