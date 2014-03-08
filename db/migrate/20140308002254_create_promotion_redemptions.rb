class CreatePromotionRedemptions < ActiveRecord::Migration
  def change
    create_table :promotion_redemptions do |t|
      t.integer :user_id, null: false
      t.integer :promotion_id, null: false

      t.timestamps
    end
  end
end
