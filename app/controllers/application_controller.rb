class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :current_user

  def current_user
    @current_user ||= User.find_by_key(GenerateKeyService.new(cookies).generate_key)
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
  
end
