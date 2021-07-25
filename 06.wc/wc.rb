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
    file_info = build_file_info(change_array_to_text(readlines), nil)
    print_file_info(file_info, l_flag)
  else
    file_names = ARGV
    file_info_list, total_file_info = build_file_info_list(file_names)
    file_info_list.each do |file|
      print_file_info(file, l_flag)
    end
    print_file_info(total_file_info, l_flag) if ARGV.size >= 2
  end
end

def build_file_info_list(file_names)
  all_texts = []
  file_info_list = file_names.map do |file_name|
    file_text = change_array_to_text(File.read(file_name).lines)
    all_texts << file_text
    build_file_info(file_text, file_name)
  end
  total_text = change_array_to_text(all_texts, "\n")
  total_file_info = build_file_info(total_text, 'total')
  [file_info_list, total_file_info]
end

def build_file_info(text, name)
  {
    line_count: text.lines.count,
    word_count: text.split.size,
    bytesize: text.bytesize,
    name: name
  }
end

def print_file_info(file_info, l_flag)
  print format(file_info[:line_count])
  unless l_flag
    print format(file_info[:word_count])
    print format(file_info[:bytesize])
  end
  puts " #{file_info[:name]}"
end

def change_array_to_text(ary, str = nil)
  ary.join(str)
end

def format(value)
  value.to_s.rjust(8)
end

main
