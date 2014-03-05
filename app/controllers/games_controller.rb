require 'slot_machine'

class GamesController < ApplicationController
  layout 'games'

  def new

  end

  def create
    if ![5, 10, 15, 20].include?(bet_amount)
      error_response(400, "Bet must be 1, 5, 10, 15, or 20")
    elsif (@current_user.balance - (bet_amount * lines)) < 0
      error_response(400, "Your balance is too low! Please deposit more Dogecoin to #{@current_user.deposit_address}")
    elsif ![1, 2, 3].include?(lines)
      error_response(400, "You must choose a valid number of lines")
    else
      slot_machine = SlotMachine.new
      game = Game.create(user_id: @current_user.id, bet_amount: bet_amount * lines, win_amount: slot_machine.play(bet_amount, lines))
      success_response(win_amount: game.win_amount, rotation_offsets: slot_machine.rotation_offsets, balance: @current_user.balance)
    end
  end

  private

  def bet_amount
    params[:bet_amount].to_i
  end

  def lines
    params[:lines].to_i
  end

end
