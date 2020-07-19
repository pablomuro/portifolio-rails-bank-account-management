class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.boolean :active
      t.string :account_number, limit: 7
      t.string :password_digest
      t.decimal :money_amount, precision: 10, scale: 2

      t.timestamps
    end
    add_index :accounts, :account_number, unique: true
  end
end
