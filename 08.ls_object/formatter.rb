# frozen_string_literal: true

require './file_list'

class Formatter
  attr_reader :file_paths, :file_details, :long_format

  def initialize(params, pathname)
    file_list = FileList.new(params, pathname)
    @file_paths = params[:reverse] ? file_list.paths.reverse! : file_list.paths
    @file_details = file_list.collect_data
    @long_format = params[:long_format]
  end

  def run_ls
    long_format ? ls_long : ls_short
  end

  def ls_long
    total = "total #{file_details[:block_total]}"
    body = render_long_format_body(file_details[:each_data])
    [total, *body].join("\n")
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

  def ls_short
    column = 3.0
    row_count = (file_paths.count.to_f / column).ceil
    transposed_file_paths = safe_transpose(file_paths.each_slice(row_count).to_a)
    format_table(transposed_file_paths)
  end

  def safe_transpose(nested_file_names)
    nested_file_names[0].zip(*nested_file_names[1..])
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
