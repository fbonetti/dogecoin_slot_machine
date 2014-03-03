class WithdrawalService

  def initialize(user_id, withdrawal_address)
    @user_id = user_id
    @withdrawal_address = withdrawal_address
  end

  def withdraw
    user = User.find(@user_id)
    withdrawal = Withdrawal.create(user_id: @user_id, withdrawal_address: @withdrawal_address, amount: user.balance)
    rpc_client.sendtoaddress withdrawal.withdrawal_address, withdrawal.amount
  end

  private

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

end