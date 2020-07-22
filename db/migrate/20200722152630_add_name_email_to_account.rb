class AddNameEmailToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :name, :string, limit: 50
    add_column :accounts, :email, :string, limit: 50
  end
end
