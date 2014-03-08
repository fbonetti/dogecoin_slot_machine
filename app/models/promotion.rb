class Promotion < ActiveRecord::Base
  has_many :promotion_redemptions

  validates :amount, numericality: {less_than_or_equal_to: 200}
  validates :limit, numericality: {less_than_or_equal_to: 100}
end
