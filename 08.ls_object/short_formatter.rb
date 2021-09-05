# frozen_string_literal: true

require './formatter'

class ShortFormatter < Formatter
  def run_ls
    column = 3.0
    row_count = (@file_list.paths.count.to_f / column).ceil
    transposed_file_paths = safe_transpose(@file_list.paths.each_slice(row_count).to_a)
    format_table(transposed_file_paths)
  end

  def safe_transpose(nested_file_names)
    nested_file_names[0].zip(*nested_file_names[1..])
  end

  def format_table(file_paths)
    file_paths.map do |row_files|
      render_format_row(row_files)
    end.join("\n")
  end

  def render_format_row(row_files)
    row_files.map do |file_path|
      basename = file_path ? File.basename(file_path) : ''
      basename.ljust(30)
    end.join.rstrip
  end
end
