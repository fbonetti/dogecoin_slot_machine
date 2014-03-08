class AddIPaddressToAllTables < ActiveRecord::Migration
  def change
    add_column :games,                 :ip_address, :string
    add_column :withdrawals,           :ip_address, :string
    add_column :promotion_redemptions, :ip_address, :string
  end
end
