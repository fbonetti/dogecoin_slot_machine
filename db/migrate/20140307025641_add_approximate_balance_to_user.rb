class AddApproximateBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :approximate_balance, :integer, default: 0
  end
end
