require 'optparse'
require 'date'
opt = OptionParser.new
year = Date.today.year
month = Date.today.month
opt.on('-y YEAR') { |y| year = y.to_i }
opt.on('-m MONTH') { |m| month = m.to_i }
opt.parse!(ARGV)

first_day_of_the_week = Date.new(year, month, 1).wday
last_day = Date.new(year, month, -1).day
start_line = "   " * first_day_of_the_week

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print start_line

(1..last_day).each do |day|
  if Date.new(year, month, day).wday == 6 || day == last_day
    puts day.to_s.rjust(2)
  else
    print "#{day.to_s.rjust(2)} "
  end
end
puts
