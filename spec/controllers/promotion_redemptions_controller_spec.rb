require 'spec_helper'

describe PromotionRedemptionsController do
  describe "POST #create" do
    it "should raise a 400 if the promo code is invalid" do
      post :create, promotion_redemption: {code: "123"}
      response.status.should == 400
    end
  end
end
