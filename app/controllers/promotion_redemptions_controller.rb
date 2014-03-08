class PromotionRedemptionsController < ApplicationController

  def create
    promotion = Promotion.find_by_code(promotion_redemption_params[:code])
    return error_response(400, "Invalid code") if promotion.nil?
    
    promotion_redemption = PromotionRedemption.new(user_id: @current_user.id, promotion_id: promotion.id, ip_address: request.remote_ip)

    if promotion_redemption.save 
      success_response(balance: @current_user.balance)
    else
      error_response(403, "Code has expired")
    end
  end

  private

  def promotion_redemption_params
    params.require(:promotion_redemption).permit(:code)
  end

end
