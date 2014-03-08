class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :code, null: false
      t.text :description, null: false
      t.integer :amount, null: false
      t.integer :limit, null: false

      t.timestamps
    end
  end
end
