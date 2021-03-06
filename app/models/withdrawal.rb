require 'dogecoin_rpc'

class Withdrawal < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true, numericality: {only_integer: true}
  validates :amount, presence: true, numericality: {greater_than: 0}
  validate :valid_withdrawal_address

  after_create :update_approximate_user_balance

  private

  def valid_withdrawal_address
    if rpc_client.validateaddress(withdrawal_address.to_s)["isvalid"] == false
      errors.add(:withdrawal_address, "must be a valid dogecoin address")
    end
  end

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

  def update_approximate_user_balance
    self.user.update_approximate_balance
  end

end
