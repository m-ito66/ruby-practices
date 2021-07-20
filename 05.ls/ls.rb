#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'date'

def main
  reverse_flag = list_flag = false
  OptionParser.new do |opt|
    items, hidden_items = recieve_items
    opt.on('-a') { items += hidden_items }
    opt.on('-r') { reverse_flag = true }
    opt.on('-l') { list_flag = true }
    opt.parse!(ARGV)
    sorted_items = reverse_flag ? items.sort.reverse : items.sort
    list_flag ? list_process(sorted_items) : no_list_process(sorted_items)
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
  list_stats = []
  all_block = 0
  items.each do |item|
    item_state = File.stat(item)
    all_block += item_state.blocks
    list_stats << "#{define_list_variable(item_state)} #{item}"
  end
  print_list(all_block, list_stats)
end

def print_list(block, items)
  puts "total #{block}"
  items.each { |item| puts item }
end

def define_list_variable(item_state)
  file_type = item_state.ftype == 'file' ? '-' : 'd'
  file_permission = change_permisson(item_state.mode.to_s(8))
  link_counts = item_state.nlink
  owner_name = Etc.getpwuid(item_state.uid).name
  group_name = Etc.getgrgid(item_state.gid).name
  item_size = item_state.size
  time = timestamp(item_state)
  "#{file_type}#{file_permission}#{format(link_counts, 3)}#{format(owner_name, 6)}#{format(group_name, 7)}#{format(item_size, 6)}#{time}"
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
  permission = ''
  correspondence = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
                     '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  (-3..-1).each do |num|
    permission += correspondence[text[num]]
  end
  permission
end

def no_list_process(items)
  element_counts = (items.count / 3.0).ceil
  (0..element_counts - 1).each do |num|
    files = [items[num], items[num + element_counts], items[num + element_counts * 2]]
    express_3lines(files)
  end
end

def express_3lines(files)
  files.each do |file|
    print file ? file.ljust(30) : ''
  end
  puts
end

main
