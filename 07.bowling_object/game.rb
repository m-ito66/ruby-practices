# frozen_string_literal: true

require './frame'

class Game
  def initialize(pins)
    @frames =
      (0..9).map do
        pins[0] == 'X' ? Frame.new(pins.shift(1)) : Frame.new(pins.shift(2))
      end
    @frames << Frame.new(pins)
  end

  def score
    point = 0
    (0..9).each do |num|
      point += bonus_score(num)
    end
    point += @frames.last.third_shot.score
  end

  def bonus_score(num)
    if @frames[num].strike? && @frames[num + 1].strike?
      20 + @frames[num + 2].first_shot.score
    elsif @frames[num].strike?
      10 + @frames[num + 1].score
    elsif @frames[num].spare?
      10 + @frames[num + 1].first_shot.score
    else
      @frames[num].score
    end
  end
end

pins = ARGV[0].split(',')
game = Game.new(pins)
p game.score
