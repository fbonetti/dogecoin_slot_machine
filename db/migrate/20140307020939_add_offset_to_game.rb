class AddOffsetToGame < ActiveRecord::Migration
  def change
    add_column :games, :left_reel, :integer
    add_column :games, :middle_reel, :integer
    add_column :games, :right_reel, :integer
  end
end
