require 'spec_helper'

describe PromotionRedemption do
  
  describe "validations" do
    it "should not allow a user to redeem a promotion more than once" do
      promotion = create(:promotion)
      first_promotion_redemption = PromotionRedemption.create(user_id: 1, promotion_id: promotion.id)
      second_promotion_redemption = PromotionRedemption.new(user_id: 1, promotion_id: promotion.id)

      second_promotion_redemption.valid?.should be_false
    end

    it "should not allow the same ip_address to redeem a promotion more than once" do
      promotion = create(:promotion)
      first_promotion_redemption = PromotionRedemption.create(user_id: 1, promotion_id: promotion.id, ip_address: "71.194.24.178")
      second_promotion_redemption = PromotionRedemption.new(user_id: 2, promotion_id: promotion.id, ip_address: "71.194.24.178")

      second_promotion_redemption.valid?.should be_false
    end

    it "should not allow the number of promotion_redemptions to exceed the promotion limit" do
      promotion = build(:promotion)
      promotion.limit = 5
      promotion.save

      promotion_redemptions = (1..6).map do |i|
        promotion_redemption = PromotionRedemption.new(user_id: i, promotion_id: promotion.id, ip_address: "#{i}")
        promotion_redemption.save
      end
      
      promotion_redemptions[0..4].all?.should be_true
      promotion_redemptions.last.should be_false
    end
  end

end
