class Promotion < ActiveRecord::Base
  has_many :promotion_redemptions
end
