class AdminController < ApplicationController
  http_basic_authenticate_with name: SECRETS["ADMIN_USERNAME"], password: SECRETS["ADMIN_PASSWORD"]
  layout 'admin'

  def statistics
    @average_payback_percent = Game.average_payback_percent
    @average_games_per_day = Game.average_games_per_day
    @total_games = Game.count

    @profit = Game.total_profit - PromotionRedemption.total_amount
    @total_approximate_user_balance = User.total_approximate_balance
    @wallet_balance = rpc_client.getbalance

    @promotion_payout = PromotionRedemption.total_amount
    @outstanding_redemptions = Promotion.sum(:limit) - PromotionRedemption.count
    @promotion_count = Promotion.count
  end

  private

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

end
