#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'date'

def main
  a_flag = r_flag = l_flag = false
  OptionParser.new do |opt|
    opt.on('-a') { a_flag = true }
    opt.on('-r') { r_flag = true }
    opt.on('-l') { l_flag = true }
    opt.parse!(ARGV)
    items = read_items(a_flag, r_flag)
    l_flag ? line_item_info(items) : list_only_name(items, 3)
  end
end

def read_items(a_flag, r_flag)
  items = []
  hidden_items = []
  Dir.foreach('.') do |item|
    item[0] == '.' ? hidden_items << item : items << item
  end
  items = a_flag ? (items + hidden_items).sort : items.sort
  items = r_flag ? items.sort.reverse : items
end

def line_item_info(items)
  all_block = 0
  list_stats =
    items.map do |item|
      item_state = File.stat(item)
      all_block += item_state.blocks
      "#{define_list_variable(item_state)} #{item}"
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
  correspondence_table = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }
  (-3..-1).each do |num|
    permission += correspondence_table[text[num]]
  end
  permission
end

def list_only_name(items, column)
  row_count = (items.count / column.to_f).ceil
  row_count.times do |column|
    items.each_slice(row_count) do |item|
      print item[num] ? item[num].ljust(30) : ''
    end
    puts
  end
end

main
