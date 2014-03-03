class AddWithdrawalAddressToWithdrawal < ActiveRecord::Migration
  def change
    add_column :withdrawals, :withdrawal_address, :string, null: false
  end
end
