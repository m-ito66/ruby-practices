# frozen_string_literal: true

require 'optparse'
require 'pathname'

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

module Format

  def run_ls(long_format, file_paths)
    long_format ? ls_long(file_paths) : ls_short(file_paths)
  end

  def ls_long(file_paths)
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

  def ls_short(file_paths)
    column = 3.0
    row_count = (file_paths.count.to_f / column).ceil
    transposed_file_paths = safe_transpose(file_paths.each_slice(row_count).to_a)
    format_table(transposed_file_paths)
  end

  def safe_transpose(nested_file_names)
    nested_file_names[0].zip(*nested_file_names[1..-1])
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
end
