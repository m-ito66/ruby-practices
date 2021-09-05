# frozen_string_literal: true

require './formatter'

class LongFormatter < Formatter
  def run_ls
    total = "total #{FileDetail.count_block(@file_list.paths)}"
    body = render_format_body
    [total, *body].join("\n")
  end

  def render_format_body
    max_sizes = @file_list.research_max_size
    @file_list.file_details.map do |data|
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
