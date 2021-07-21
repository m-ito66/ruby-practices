#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  l_flag = false
  OptionParser.new do |opt|
    opt.on('-l') { l_flag = true }
    opt.parse!(ARGV)
  end
  if ARGV.empty?
    no_argument_process(l_flag)
  else
    file_info, total_info = receive_file_info
    file_info.each { |file| write_file_info(file, l_flag) }
    write_file_info(total_info, l_flag) if ARGV.size >= 2
  end
end

def no_argument_process(l_flag)
  text = readlines
  total_line_count = total_word_count = total_bytesize = 0
  text.each do |sentence|
    total_line_count += 1
    total_word_count += sentence.split.size
    total_bytesize += sentence.bytesize
  end
  total_text_info = [total_line_count, total_word_count, total_bytesize]
  write_file_info(total_text_info, l_flag)
end

def receive_file_info
  total_line_count = total_word_count = total_file_size = 0
  each_file_info = []
  ARGV.each do |file_name|
    file_text = File.read(file_name)
    line_count = file_text.lines.size
    word_count = file_text.split.size
    file_size = file_text.size
    each_file_info << [line_count, word_count, file_size, " #{file_name}"]
    total_line_count += line_count
    total_word_count += word_count
    total_file_size += file_size
  end
  total_file_info = [total_line_count, total_word_count, total_file_size, ' total']
  [each_file_info, total_file_info]
end

LINE_COUNT_INDEX = 0
WORD_COUNT_INDEX = 1
FILE_SIZE_INDEX = 2
FILE_NAME_INDEX = 3
def write_file_info(file, l_flag)
  print file[LINE_COUNT_INDEX].to_s.rjust(8)
  unless l_flag
    print file[WORD_COUNT_INDEX].to_s.rjust(8)
    print file[FILE_SIZE_INDEX].to_s.rjust(8)
  end
  puts file[FILE_NAME_INDEX] || ''
end

def format(value)
  value.to_s.rjust(8)
end

main
