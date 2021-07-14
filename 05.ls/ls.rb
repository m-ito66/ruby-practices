#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'
require 'date'

@reverse_flag = @list_flag = 0
def main
  OptionParser.new do |opt|
    recieve_items
    opt.on {}
    opt.on('-a') { @sorted_items += @hidden_items }
    opt.on('-r') { @reverse_flag = 1 }
    opt.on('-l') { @list_flag = 1 }
    opt.parse!(ARGV)
    reverse_process
    @list_flag == 1 ? list_process : no_list_process
  end
end

def recieve_items
  @items = []
  @hidden_items = []
  Dir.foreach('.') do |item|
    item[0] == '.' ? @hidden_items << item : @items << item
  end
  @sorted_items = @items.sort
end

def reverse_process
  @sorted_items = @reverse_flag == 1 ? @sorted_items.sort.reverse : @sorted_items.sort
end

def list_process
  @sorted_items.each do |sorted_item|
    @item_state = File.stat(sorted_item)
    define_list_variable
    puts "#{@file_type}#{@file_permission}  #{@link_counts}  #{@owner_name}\
        　#{@group_name}  #{@item_size}  #{@timestamp}  #{sorted_item}"
  end
end

def define_list_variable
  @file_type = @item_state.ftype == 'file' ? '-' : 'd'
  @file_permission = change_permisson(@item_state.mode.to_s(8))
  @link_counts = @item_state.nlink
  @owner_name = Etc.getpwuid(@item_state.uid).name
  @group_name = Etc.getgrgid(@item_state.gid).name
  @item_size = @item_state.size
  timestamp
end

def timestamp
  month = @item_state.mtime.month
  day = @item_state.mtime.day
  hour = @item_state.mtime.hour
  minute = @item_state.mtime.min
  @timestamp = "#{month}  #{day}  #{hour}:#{minute}"
end

def change_permisson(text)
  num = -3
  permission = ''
  correspondence = { '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--',
                     '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  while num <= -1
    permission += correspondence[text[num]]
    num += 1
  end
  permission
end

def no_list_process
  element_counts = (@sorted_items.size / 3.0).ceil
  num = 0
  while num < element_counts
    @line1_file = @sorted_items[num]
    @line2_file = @sorted_items[num + element_counts]
    @line3_file = @sorted_items[num + element_counts * 2]
    express_3lines
    num += 1
  end
end

def express_3lines
  print @line1_file ? @line1_file.ljust(30) : ''
  print @line2_file ? @line2_file.ljust(30) : ''
  puts @line3_file ? @line3_file.ljust(30) : ''
end

main
