class ChangeUserApproximateBalanceToDecimal < ActiveRecord::Migration
  def change
    change_column :users, :approximate_balance, :decimal
  end
end
