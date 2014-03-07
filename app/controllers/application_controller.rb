require 'dogecoin_rpc'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :current_user

  def current_user
    @current_user ||= User.find_by_key(get_key)
  end

  def success_response(data)
    render json: {
      status: :success,
      data: data
    }, status: 200
  end

  def error_response(status_code, message)
    render json: {
      status: :error,
      message: message
    }, status: status_code
  end

  private

  # Generate a new token, address, and user if the key is invalid or doesn't exist in the database

  def get_key
    if cookies[:key].blank? || cookies[:key].length != 32 || cookies[:key].match(/\H/) || !User.exists?(key: cookies[:key])
      key = get_unique_key
      deposit_address = get_unique_address(key)
      user = User.create(key: key, deposit_address: deposit_address, ip_address: request.remote_ip)
      cookies[:key] = user.key
    else
      cookies[:key]
    end
  end

  def rpc_client
    @rpc_client ||= DogecoinRPC.new(SECRETS["DOGECOIN_RPC_URL"])
  end

  def get_unique_key
    loop do
      random_key = Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now}")
      break random_key unless User.exists?(key: random_key)
    end
  end

  # The chance of generating a non-unique deposit address is astronomically small,
  # but it doesn't hurt to check

  def get_unique_address(account_label)
    loop do
      random_address = rpc_client.getnewaddress(account_label)
      break random_address unless User.exists?(deposit_address: random_address)
    end
  end
  
end
