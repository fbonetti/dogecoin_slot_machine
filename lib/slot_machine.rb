require 'securerandom'

class Reel
  attr_reader :rotation_offset

  def initialize(*symbols)
    @symbols = symbols
    @rotation_offset = 0
  end

  def spin
    random_rotation_amount = SecureRandom.random_number(@symbols.count - 1)
    @rotation_offset = (@rotation_offset + random_rotation_amount) % @symbols.count
    @symbols.rotate!(random_rotation_amount)
  end

  def top_line
    @symbols[0]
  end

  def middle_line
    @symbols[1]
  end

  def bottom_line
    @symbols[2]
  end
end

class SlotMachine

  def initialize
    @reels = []
    @reels << Reel.new(:orange, :rocket, :orange, :cherry, :moon, :cherry, :bell, :cherry, :rocket, :lemon, :rocket, :lemon, :orange, :cherry, :bell, :cherry, :doge, :bell, :orange, :lemon)
    @reels << Reel.new(:lemon, :doge, :orange, :cherry, :bell, :orange, :rocket, :lemon, :bell, :lemon, :rocket, :moon, :bell, :lemon, :bell, :orange, :cherry, :rocket, :orange, :lemon)
    @reels << Reel.new(:lemon, :rocket, :bell, :orange, :bell, :cherry, :orange, :cherry, :lemon, :bell, :lemon, :orange, :bell, :lemon, :doge, :lemon, :cherry, :lemon, :moon, :orange)
  end

  def play(bet)
    bet = bet.to_i
    @reels.each(&:spin)
    payout(bet, middle_line)
  end

  def all_lines
    {
      top_line: top_line,
      middle_line: middle_line,
      bottom_line: bottom_line
    }
  end

  def rotation_offsets
    {
      left_reel:   @reels[0].rotation_offset,
      middle_reel: @reels[1].rotation_offset,
      right_reel:  @reels[2].rotation_offset
    }
  end

  private

  def payout(bet, line)
    amount = (bet * 2) if line[0] == :cherry
    amount = (bet * 5) if line[0] == :cherry && line[1] == :cherry
    amount = (bet * pay_table[line]) if pay_table[line]
    amount.to_i
  end

  def pay_table
    {
      [:doge,   :doge,   :doge]   => 500,
      [:moon,   :moon,   :moon]   => 100,
      [:rocket, :rocket, :rocket] => 50,
      [:bell,   :bell,   :bell]   => 20,
      [:orange, :orange, :orange] => 15,
      [:cherry, :cherry, :cherry] => 10
    }
  end

  def top_line
    @reels.map(&:top_line)
  end

  def middle_line
    @reels.map(&:middle_line)
  end

  def bottom_line
    @reels.map(&:bottom_line)
  end

end