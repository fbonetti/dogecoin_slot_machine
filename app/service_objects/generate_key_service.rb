require 'dogecoin_rpc'

class GenerateKeyService

  def initialize(cookies)
    @cookies = cookies
  end

  # Generate a new token, address, and user if the key is invalid or doesn't exist in the database

  def generate_key
    if @cookies[:key].blank? || @cookies[:key].length != 32 || @cookies[:key].match(/\H/) || !User.exists?(key: @cookies[:key])
      key = get_unique_key
      deposit_address = get_unique_address(key)
      user = User.create(key: key, deposit_address: deposit_address)
      @cookies[:key] = user.key
    else
      @cookies[:key]
    end
  end

  private

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