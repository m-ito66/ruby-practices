require 'minitest/autorun'
require './game'

class BowlingTest < Minitest::Test
  def test_frame
    frame = Frame.new([3,5])
    assert_equal 8, frame.score
  end

  def test_score300
    pins = "X,X,X,X,X,X,X,X,X,X,X,X".split(',')
    game = Game.new(pins)
    frames = game.split_frames
    assert_equal 300, game.score(frames)
  end

  def test_score139
    pins = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'.split(',')
    game = Game.new(pins)
    frames = game.split_frames
    assert_equal 139, game.score(frames)
  end

  def test_score164
    pins = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'.split(',')
    game = Game.new(pins)
    frames = game.split_frames
    assert_equal 164, game.score(frames)
  end

  def test_score107
    pins = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'.split(',')
    game = Game.new(pins)
    frames = game.split_frames
    assert_equal 107, game.score(frames)
  end

  def test_score134
    pins = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'.split(',')
    game = Game.new(pins)
    frames = game.split_frames
    assert_equal 134, game.score(frames)
  end
end