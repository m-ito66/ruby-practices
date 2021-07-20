#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'date'

def main
  reverse_flag = list_flag = 0
  OptionParser.new do |opt|
    items, hidden_items = recieve_items
    opt.on {}
    opt.on('-a') { items += hidden_items }
    opt.on('-r') { reverse_flag = 1 }
    opt.on('-l') { list_flag = 1 }
    opt.parse!(ARGV)
    sorted_items = reverse_flag == 1 ? items.sort.reverse : items.sort
    list_flag == 1 ? list_process(sorted_items) : no_list_process(sorted_items)
  end
end

def recieve_items
  items = []
  hidden_items = []
  Dir.foreach('.') do |item|
    item[0] == '.' ? hidden_items << item : items << item
  end
  [items, hidden_items]
end

def list_process(items)
  all_item_blocks(items)
  items.each do |item|
    item_state = File.stat(item)
    list_variables = define_list_variable(item_state)
    list_variables.each { |variable| print variable }
    puts " #{item}"
  end
end

def all_item_blocks(items)
  all_item_blocks = 0
  items.each do |item|
    item_state = File.stat(item)
    item_block = item_state.blocks
    all_item_blocks += item_block
  end
  puts "total #{all_item_blocks}"
end

def define_list_variable(item_state)
  file_type = item_state.ftype == 'file' ? '-' : 'd'
  file_permission = change_permisson(item_state.mode.to_s(8))
  link_counts = item_state.nlink
  owner_name = Etc.getpwuid(item_state.uid).name
  group_name = Etc.getgrgid(item_state.gid).name
  item_size = item_state.size
  time = timestamp(item_state)
  [file_type, file_permission, format(link_counts, 3), format(owner_name, 6),
   format(group_name, 7), format(item_size, 7), time]
end

def timestamp(item_state)
  month = item_state.mtime.month
  day = item_state.mtime.day
  hour = item_state.mtime.hour
  minute = item_state.mtime.min
  "#{format(month, 3)}#{format(day, 3)}#{format("#{hour}:#{minute}", 6)}"
end

def format(text, num)
  text.to_s.rjust(num)
end

def change_permisson(text)
  num = -3
  permission = ''
  correspondence = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
                     '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  while num <= -1
    permission += correspondence[text[num]]
    num += 1
  end
  permission
end

def no_list_process(items)
  element_counts = (items.count / 3.0).ceil
  num = 0
  while num < element_counts
    line1_file = items[num]
    line2_file = items[num + element_counts]
    line3_file = items[num + element_counts * 2]
    express_3lines(line1_file, line2_file, line3_file)
    num += 1
  end
end

def express_3lines(item1, item2, item3)
  print item1 ? item1.ljust(30) : ''
  print item2 ? item2.ljust(30) : ''
  puts item3 ? item3.ljust(30) : ''
end

main
