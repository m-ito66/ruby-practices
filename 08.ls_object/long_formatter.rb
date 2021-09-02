# frozen_string_literal: true

require './formatter'

class LongFormatter < Formatter
  def run_ls
    file_details = FileList.collect_details(@file_paths)
    total = "total #{FileDetail.count_block(@file_paths)}"
    body = render_long_format_body(file_details)
    [total, *body].join("\n")
  end

  def render_long_format_body(file_details)
    max_sizes = FileList.research_max_size(file_details)
    file_details.map do |data|
      format_row(data, *max_sizes)
    end
  end

  def format_row(data, max_nlink, max_user, max_group, max_size)
    [
      data.type_and_mode,
      "  #{data.nlink.rjust(max_nlink)}",
      " #{data.user.ljust(max_user)}",
      "  #{data.group.ljust(max_group)}",
      "  #{data.size.rjust(max_size)}",
      " #{data.mtime}",
      " #{data.basename}"
    ].join
  end
end
