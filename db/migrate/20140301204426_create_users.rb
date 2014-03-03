class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :key,             null: false
      t.string  :deposit_address, null: false

      t.timestamps
    end
  end
end
