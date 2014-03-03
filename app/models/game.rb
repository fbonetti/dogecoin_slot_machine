class Game < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, numericality: {only_integer: true}
  validates :bet_amount, presence: true, numericality: {only_integer: true}
  validates :win_amount, presence: true, numericality: {only_integer: true}
end
