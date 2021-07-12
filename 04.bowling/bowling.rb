# frozen_string_literal: true

# 各投を配列にする
pins = ARGV[0].split(',').map do |pin|
  pin = 10 if pin == 'X'
  pin.to_i
end

# フレーム毎に配列を分割
num = 0
count = 0
@frames = []
while num < pins.size
  # ストライクの処理
  if pins[num] == 10
    @frames << [pins[num]]
    num += 1
  else
    @frames << [pins[num], pins[num + 1]]
    num += 2
  end
  count += 1
  # 最終フレームの処理
  if count == 9
    @frames << pins[num..pins.size]
    break
  end
end

# ストライクの判定
def strike(num)
  @frames[num].size == 1
end

# スペアの判定
def spare(num)
  @frames[num].sum == 10
end

# スコアの計算
score = 0
num = 0
while num < 10
  score +=
    if strike(num) && strike(num + 1)
      20 + @frames[num + 2][0]
    elsif strike(num)
      10 + @frames[num + 1][0] + @frames[num + 1][1]
    elsif spare(num)
      10 + @frames[num + 1][0]
    else
      @frames[num].sum
    end
  num += 1
end

puts score
