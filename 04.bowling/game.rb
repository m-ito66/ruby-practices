# frozen_string_literal: true

require './frame'
require 'byebug'

class Game
  attr_reader :pins

  def initialize(pins)
    @pins = pins
  end

  def split_frames
    frames = []
    9.times do |num|
      frames << if pins[0] == 'X'
                  Frame.new(pins.shift(1))
                else
                  Frame.new(pins.shift(2))
                end
    end
    frames << Frame.new(pins)
  end

  def score(frames)
    point = 0
    10.times do |num|
      point += bonus_score(frames, num)
      num += 1
    end
    point += frames.last.third_shot.score
  end

  def bonus_score(frames, num)
      if frames[num].strike? && frames[num + 1].strike?
        20 + frames[num + 2].first_shot.score
      elsif frames[num].strike?
        10 + frames[num + 1].score
      elsif frames[num].spare?
        10 + frames[num + 1].first_shot.score
      else
        frames[num].score
      end
  end
end

# pins ||= ARGV[0].split(',')
# game = Game.new(pins)
# frames = game.split_frames
# debugger
# p game.score(frames)
