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
  attr_reader :type_and_mode, :nlink, :user, :group, :size, :mtime, :basename

  def initialize(file_path)
    stat = File::Stat.new(file_path)
    @type_and_mode = format_type_and_mode(file_path)
    @nlink = stat.nlink.to_s
    @user = Etc.getpwuid(stat.uid).name
    @group = Etc.getgrgid(stat.gid).name
    @size = stat.size.to_s
    @mtime = stat.mtime.strftime('%b %e %H:%M')
    @basename = File.basename(file_path)
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
