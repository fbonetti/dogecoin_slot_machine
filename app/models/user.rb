require 'dogecoin_rpc'

class User < ActiveRecord::Base
  has_many :games
  has_many :withdrawals
  has_many :promotion_redemptions

  validates :key, length: {is: 32}, format: {with: /\h/}, presence: true, uniqueness: true
  validates :deposit_address, presence: true, uniqueness: true
  validates :username, uniqueness: true, length: {minimum: 1, maximum: 20}, format: {with: /\A\w+\z/}

  before_create :assign_random_username

  def self.total_approximate_balance
    User.sum(:approximate_balance)
  end

  def balance
    total_deposits     = rpc_client.getreceivedbyaddress(self.deposit_address)
    total_win_amount   = self.games.sum(:win_amount)
    total_redemptions  = self.promotion_redemptions.sum(:amount)
    total_bet_amount   = self.games.sum(:bet_amount)
    total_withdrawals  = self.withdrawals.sum(:amount)

    (total_deposits + total_win_amount + total_redemptions) - (total_bet_amount + total_withdrawals)
  end

  def qr_code_link
    "https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=#{self.deposit_address}&choe=UTF-8"
  end

  # Users cannot withdraw more than once in a 60 second period

  def can_withdraw?
    self.withdrawals.count == 0 ||
    (DateTime.now.to_i - self.withdrawals.order("created_at DESC").first.created_at.to_i) > 60.seconds
  end

  def update_approximate_balance
    self.approximate_balance = self.balance
    self.save
  end

  private

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

  def assign_random_username
    self.username = loop do
      random_username = %w[Doge Shibe Crypto Anon User].sample + rand(1..1_000_000).to_s
      break random_username unless User.exists?(username: random_username)
    end
  end

end
