class WithdrawalsController < ApplicationController

  def create
    if @current_user.balance <= 0
      error_response(403, "Your balance is too low!")
    elsif address_valid?(params[:withdrawal_address]) == false
      error_response(400, "You must enter a valid Dogecoin address")
    elsif !@current_user.can_withdraw?
      error_response(403, "Please wait 60 seconds before making another withdrawal request")
    else
      WithdrawalService.new(@current_user.id, params[:withdrawal_address]).withdraw
      success_response(balance: 0)
    end
  end

  private

  def address_valid?(withdrawal_address)
    rpc_client.validateaddress(withdrawal_address.to_s)["isvalid"]
  end

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

end
