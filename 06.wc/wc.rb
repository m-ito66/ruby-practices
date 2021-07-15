#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  if ARGV[0] == '-l'
    optparse
    if ARGV.size.zero?
      # -lオプションを指定されたのみ。標準入力へ
      text = readlines
      puts text.size.to_s.rjust(8)
    else
      # ARGV内はファイル情報だけ。lines情報を取り出す
      receive_file_info
      print_list
      write_total_lines
    end
  elsif ARGV.size.zero?
    # オプションが指定されていない時
    no_argument_and_option
  # オプション、引数ともに指定なしなので、標準入力へ
  else
    # オプションの指定はなし、引数は存在するので、ARGVからファイル情報取得へ
    receive_file_info
    write_file_info
    write_total_info
  end
end

def optparse
  OptionParser.new do |opt|
    opt.on('-l') {}
    opt.parse!(ARGV)
  end
end

def receive_file_info
  num = 0
  @total_lines = @total_words = @total_size = 0
  @each_file_info = []
  while num < ARGV.size
    word_counts = 0
    file = File.new(ARGV[num])
    lines = []
    # 各行の情報を取得
    file.each do |line|
      array_words = line.split(/\s/).delete_if { |word| word == '' }
      word_counts += array_words.size
      lines << line
    end
    line_counts = /\n$/.match?(lines.last) ? lines.count : lines.count - 1
    file_name = " #{ARGV[num]}"
    @each_file_info << [line_counts, word_counts, file.size, file_name]
    num += 1
    @total_lines += line_counts
    @total_words += word_counts
    @total_size += file.size
  end
end

def print_list
  @each_file_info.each do |file|
    print file[0].to_s.rjust(8)
    puts file[3]
  end
end

def write_file_info
  @each_file_info.each do |file|
    print file[0].to_s.rjust(8)
    print file[1].to_s.rjust(8)
    print file[2].to_s.rjust(8)
    puts file[3]
  end
end

def write_total_elements
  print @total_lines.to_s.rjust(8)
  print @total_words.to_s.rjust(8)
  print @total_size.to_s.rjust(8)
end

def write_total_lines
  return unless ARGV.size >= 2

  print @total_lines.to_s.rjust(8)
  puts ' total'
end

def write_total_info
  return unless ARGV.size >= 2

  write_total_elements
  puts ' total'
end

def no_argument_and_option
  text = readlines
  text_stat = []
  text.each do |sentence|
    word_arrays = sentence.split(/\s/).delete_if { |word| word == '' }
    text_stat << [word_arrays.size, sentence.bytesize]
  end
  @total_lines = @total_words = @total_size = 0
  text_stat.each do |word|
    @total_words += word[0]
    @total_size += word[1]
  end
  @total_lines = text_stat.size
  write_total_elements
  puts
end

main
