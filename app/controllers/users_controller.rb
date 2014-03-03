class UsersController < ApplicationController

  def update
    if @current_user.update_attributes(user_params)
      success_response(username: @current_user.username)
    else
      error_response(400, @current_user.errors.messages.first.join(' ').capitalize)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end

end
