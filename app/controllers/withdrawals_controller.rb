class WithdrawalsController < ApplicationController

  def create
    if @current_user.balance <= 0
      error_response(403, "Your balance is too low!")
    elsif address_valid?(withdrawal_params[:withdrawal_address]) == false
      error_response(400, "You must enter a valid Dogecoin address")
    elsif !@current_user.can_withdraw?
      error_response(403, "Please wait 60 seconds before making another withdrawal request")
    elsif @current_user.balance > rpc_client.getbalance
      error_response(403, "There was an error on the server. Please try again later")
    else
      ActiveRecord::Base.transaction do
        withdrawal = Withdrawal.create(
          user_id: @current_user.id, withdrawal_address: withdrawal_params[:withdrawal_address],
          amount: @current_user.balance, ip_address: request.remote_ip
        )
        rpc_client.sendtoaddress withdrawal.withdrawal_address, withdrawal.amount.to_f
        success_response(balance: 0.0)
      end
    end
  end

  private

  def withdrawal_params
    params.require(:withdrawal).permit(:withdrawal_address)
  end

  def address_valid?(withdrawal_address)
    rpc_client.validateaddress(withdrawal_address.to_s)["isvalid"]
  end

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

end
