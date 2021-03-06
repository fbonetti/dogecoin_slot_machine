class PromotionRedemption < ActiveRecord::Base
  belongs_to :user
  belongs_to :promotion

  default_scope { joins(:promotion) }

  validates_uniqueness_of :user_id, scope: :promotion_id, message: "cannot redeem a promo code more than once"
  validates_uniqueness_of :ip_address, scope: :promotion_id, message: "cannot redeem a promo code more than once"
  validate :must_not_exceed_promotion_limit

  after_create :update_approximate_user_balance

  def self.total_amount
    PromotionRedemption.sum(:amount)
  end

  private

  def must_not_exceed_promotion_limit
    if PromotionRedemption.where(promotion_id: self.promotion_id).count >= self.promotion.limit
      errors.add(:code, "has expired")
    end
  end

  def update_approximate_user_balance
    self.user.update_approximate_balance
  end

end
