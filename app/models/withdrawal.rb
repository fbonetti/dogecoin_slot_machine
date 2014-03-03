require 'dogecoin_rpc'

class Withdrawal < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true, numericality: {only_integer: true}
  validates :amount, presence: true, numericality: {only_integer: true}
  validate :valid_withdrawal_address



  private

  def valid_withdrawal_address
    if rpc_client.validateaddress(withdrawal_address.to_s)["isvalid"] == false
      errors.add(:withdrawal_address, "must be a valid dogecoin address")
    end
  end

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

end
