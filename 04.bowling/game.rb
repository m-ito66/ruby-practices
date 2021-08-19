# frozen_string_literal: true

require './frame'
require 'byebug'

class Game
  def initialize(pins)
    @pins = pins
  end

  def split_frames
    frames = []
    9.times do |num|
      frames << if @pins[0] == 'X'
                  Frame.new(@pins.shift)
                else
                  Frame.new(@pins.shift, @pins.shift)
                end
    end
    frames << Frame.new(@pins[0], @pins[1], @pins[2])
  end

  def score(frames)
    score = 0
    10.times do |num|
      score +=
        if frames[num].strike? && frames[num + 1].strike?
          20 + frames[num + 2].first_shot.score
        elsif frames[num].strike?
          10 + frames[num + 1].score
        elsif frames[num].spare?
          10 + frames[num + 1].first_shot.score
        else
          frames[num].score
        end
      num += 1
    end
    score += frames.last.third_shot.score
  end
end

# pins ||= ARGV[0].split(',')
# game = Game.new(pins)
# frames = game.split_frames
# debugger
# p game.score(frames)
