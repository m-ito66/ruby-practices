#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'pathname'
require 'optparse'
require 'byebug'

MODE_TABLE = {
  '0' => '---',
  '1' => '-x-',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

class FileList
  attr_reader :file_paths, :options
  def initialize
    opt = OptionParser.new

    @options = { long_format: false, reverse: false, dot_match: false }
    opt.on('-l') { |v| @options[:long_format] = v }
    opt.on('-r') { |v| @options[:reverse] = v }
    opt.on('-a') { |v| @options[:dot_match] = v }
    opt.parse!(ARGV)

    path = ARGV[0] || '.'
    pathname = Pathname(path)
    pattern = pathname.join('*')
    params = @options[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    @file_paths = Dir.glob(*params).sort
    @options[:reverse] ? @file_paths.reverse! : @file_paths
  end

  def run_ls
    options[:long_format] ? ls_long : ls_short
  end

  def ls_short
    column = 3.0
    row_count = (file_paths.count.to_f / column).ceil
    transposed_file_paths = safe_transpose(file_paths.each_slice(row_count).to_a)
    format_table(transposed_file_paths)
  end

  def safe_transpose(nested_file_names)
    nested_file_names[0].zip(*nested_file_names[1..-1])
  end
end

def ls_long
  row_data = file_paths.map do |file_path|
    stat = File::Stat.new(file_path)
    build_data(file_path, stat)
  end
  block_total = row_data.sum { |data| data[:blocks] }
  total = "total #{block_total}"
  body = render_long_format_body(row_data)
  [total, *body].join("\n")
end

def build_data(file_path, stat)
  {
    type_and_mode: format_type_and_mode(file_path),
    nlink: stat.nlink.to_s,
    user: Etc.getpwuid(stat.uid).name,
    group: Etc.getgrgid(stat.gid).name,
    size: stat.size.to_s,
    mtime: stat.mtime.strftime('%b %e %H:%M'),
    basename: File.basename(file_path),
    blocks: stat.blocks
  }
end

def render_long_format_body(row_data)
  max_sizes = %i[nlink user group size].map do |key|
    find_max_size(row_data, key)
  end
  row_data.map do |data|
    format_row(data, *max_sizes)
  end
end

def find_max_size(row_data, key)
  row_data.map { |data| data[key].size }.max
end

def format_type_and_mode(file_path)
  pathname = Pathname(file_path)
  type = pathname.directory? ? 'd' : '-'
  mode = format_mode(pathname.stat.mode)
  "#{type}#{mode}"
end

def format_row(data, max_nlink, max_user, max_group, max_size)
  [
    data[:type_and_mode],
    "  #{data[:nlink].rjust(max_nlink)}",
    " #{data[:user].ljust(max_user)}",
    "  #{data[:group].ljust(max_group)}",
    "  #{data[:size].rjust(max_size)}",
    " #{data[:mtime]}",
    " #{data[:basename]}"
  ].join
end

def format_mode(mode)
  digits = mode.to_s(8)[-3..-1]
  digits.gsub(/./, MODE_TABLE)
end

def format_table(file_paths)
  file_paths.map do |row_files|
    render_short_format_row(row_files)
  end.join("\n")
end

def render_short_format_row(row_files)
  row_files.map do |file_path|
    basename = file_path ? File.basename(file_path) : ''
    basename.ljust(30)
  end.join.rstrip
end

file_list = FileList.new
puts file_list.run_ls