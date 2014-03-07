class AdminController < ApplicationController
  http_basic_authenticate_with name: SECRETS["ADMIN_USERNAME"], password: SECRETS["ADMIN_PASSWORD"]
  layout 'admin'

  def statistics
    @average_payback_percent = Game.average_payback_percent
    @total_games = Game.count
    @average_games_per_day = Game.average_games_per_day
    @total_approximate_user_balance = User.total_approximate_balance
  end

end
