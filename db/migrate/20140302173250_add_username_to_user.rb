class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false, default: "Shibe"

    User.all.each do |user|
      user.username = "#{user.id + 1000}"
      user.save
    end
  end
end
