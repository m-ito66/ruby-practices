# frozen_string_literal: true

# 各投を配列にする
pins = ARGV[0].split(',').map do |pin|
  pin = 10 if pin == 'X'
  pin.to_i
end

# フレーム毎に配列を分割
frames = []
9.times do |num|
  frames << if pins[0] == 10
              [pins.shift, 0]
            else
              pins.shift(2)
            end
  # 最終フレームの処理
  frames << pins if num == 8
end

def strike(frame)
  frame == [10, 0]
end

def spare(frame)
  frame.sum == 10
end

score = 0
10.times do |num|
  score +=
    if strike(frames[num]) && strike(frames[num + 1])
      20 + frames[num + 2][0]
    elsif strike(frames[num])
      10 + frames[num + 1][0] + frames[num + 1][1]
    elsif spare(frames[num])
      10 + frames[num + 1][0]
    else
      frames[num].sum
    end
  num += 1
end

puts score
