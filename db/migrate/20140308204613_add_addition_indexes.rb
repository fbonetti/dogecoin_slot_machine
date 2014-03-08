class AddAdditionIndexes < ActiveRecord::Migration
  def change
    add_index :promotion_redemptions, :user_id
    add_index :promotion_redemptions, :promotion_id
  end
end
