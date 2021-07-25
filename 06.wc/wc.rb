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
    total_text_info = input_to_terminal
    write_file_info(total_text_info, l_flag)
  else
    file_names = ARGV
    file_info_list, total_info_list = read_file_info(file_names)
    file_info_list.each do |file|
      write_file_info(file, l_flag)
    end
    write_file_info(total_info_list, l_flag) if ARGV.size >= 2
  end
end

def input_to_terminal
  stdin_text = readlines
  line_count, word_count, bytesize = read_each_file(stdin_text)
  {
    line_count: line_count,
    word_count: word_count,
    bytesize: bytesize,
    name: nil
  }
end

def read_file_info(file_names)
  total_line_count = total_word_count = total_bytesize = 0
  each_file_info = file_names.map do |file_name|
    file_text = File.read(file_name).lines
    line_count, word_count, bytesize = read_each_file(file_text)
    total_line_count += line_count
    total_word_count += word_count
    total_bytesize += bytesize
    {
      line_count: line_count,
      word_count: word_count,
      bytesize: bytesize,
      name: file_name
    }
  end
  total_file_info =
    {
      line_count: total_line_count,
      word_count: total_word_count,
      bytesize: total_bytesize,
      name: 'total'
    }
  [each_file_info, total_file_info]
end

def read_each_file(file)
  line_count = word_count = bytesize = 0
  file.each do |sentence|
    line_count += 1
    word_count += sentence.split.size
    bytesize += sentence.bytesize
  end
  [line_count, word_count, bytesize]
end

def write_file_info(file, l_flag)
  print format(file[:line_count])
  unless l_flag
    print format(file[:word_count])
    print format(file[:bytesize])
  end
  puts " #{file[:name]}"
end

def format(value)
  value.to_s.rjust(8)
end

main
