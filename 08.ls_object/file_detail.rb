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

class FileDetail
  def initialize(file_path)
    @file_path = file_path
    @stat = File::Stat.new(file_path)
  end

  def nlink
    @stat.nlink.to_s
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def mtime
    @stat.mtime.strftime('%b %e %H:%M')
  end

  def basename
    File.basename(@file_path)
  end

  def type_and_mode
    pathname = Pathname(@file_path)
    type = pathname.directory? ? 'd' : '-'
    mode = format_mode(pathname.stat.mode)
    "#{type}#{mode}"
  end

  def blocks
    @stat.blocks
  end

  def format_mode(mode)
    digits = mode.to_s(8)[-3..]
    digits.gsub(/./, MODE_TABLE)
  end

  def self.count_block(file_paths)
    file_paths.sum do |file_path|
      File::Stat.new(file_path).blocks
    end
  end
end
