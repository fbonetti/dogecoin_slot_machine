class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.integer  :user_id, null: false
      t.integer  :amount,  null: false

      t.timestamps
    end
  end
end
