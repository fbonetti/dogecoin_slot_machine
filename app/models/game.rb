class Game < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, numericality: {only_integer: true}
  validates :bet_amount, presence: true, numericality: {only_integer: true}
  validates :win_amount, presence: true, numericality: {only_integer: true}

  after_create :update_approximate_user_balance

  def self.recent_winners
    Game.eager_load(:user)
        .where("games.win_amount > games.bet_amount")
        .order("games.created_at DESC")
        .limit(10)
  end

  def self.average_payback_percent
    Game.sum(:bet_amount).to_f / Game.sum(:win_amount).to_f * 100
  end

  def self.average_games_per_day
    (Game.count.to_f / Game.select("created_at::date").distinct.count.to_f).ceil
  end

  private

  def update_approximate_user_balance
    self.user.update_approximate_balance
  end

end
