require 'optparse'
require 'date'
require 'paint'
opt = OptionParser.new

opt.on('-y') { |y| @y = y }
opt.on('-m') { |m| @m = m }
opt.parse!(ARGV)
ARGV.unshift(Date.today.year) unless @y
ARGV.push(Date.today.month) unless @m

@year = ARGV[0].to_i
@month = ARGV[1].to_i

# 初日の曜日の取得
first_day_of_the_week = Date.new(@year, @month, 1).wday
# 最終日の日付の取得
last_day = Date.new(@year, @month, -1).day
# 1日のスタート位置の調整
start_line = "   " * first_day_of_the_week


puts "#{@month}月 #{@year}".center(20)
puts "日 月 火 水 木 金 土"
print start_line

# 今日かどうかを判定
def today?
  today = Date.today
  if today == Date.new(@year, @month, @d)
    true
  end
end

# 今日の場合は色を反転
def inverse(text)
  if today?
    Paint[text, :inverse]
  else
    text
  end
end

@d = 1
while @d < 10
  # 土曜日で改行
  if Date.new(@year, @month, @d).wday == 6
    # puts " #{@d}"
    puts inverse(" #{@d}")
  else
    print inverse(" #{@d} ")
  end
  @d += 1
end

@d = 10
while @d <= last_day
  # 土曜日か月末で改行
  if Date.new(@year, @month, @d).wday == 6 || @d == last_day
    puts inverse(@d)
  # 2桁日か1桁日で後ろの空白を調整
  else
    print inverse("#{@d} ")
  end
  @d += 1
end
puts
