class ChangeWithdrawalAmountToDecimal < ActiveRecord::Migration
  def change
    change_column :withdrawals, :amount, :decimal
  end
end
