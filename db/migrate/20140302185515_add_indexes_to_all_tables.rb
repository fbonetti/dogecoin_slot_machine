class AddIndexesToAllTables < ActiveRecord::Migration
  def change
    add_index :users, :key
    add_index :games, :user_id
    add_index :withdrawals, :user_id
  end
end
