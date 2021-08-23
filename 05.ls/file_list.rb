#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'

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
  attr_reader :paths

  def initialize(params, pathname)
    pattern = pathname.join('*')
    dot_params = params[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    @paths = Dir.glob(*dot_params).sort
  end

  def collect_data
    row_data = paths.map do |file_path|
      stat = File::Stat.new(file_path)
      build_data(file_path, stat)
    end
    block_total = row_data.sum { |data| data[:blocks] }
    { each_data: row_data, block_total: block_total }
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

  def format_type_and_mode(file_path)
    pathname = Pathname(file_path)
    type = pathname.directory? ? 'd' : '-'
    mode = format_mode(pathname.stat.mode)
    "#{type}#{mode}"
  end

  def format_mode(mode)
    digits = mode.to_s(8)[-3..]
    digits.gsub(/./, MODE_TABLE)
  end
end
