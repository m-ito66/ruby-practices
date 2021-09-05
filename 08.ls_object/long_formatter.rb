# frozen_string_literal: true

require './formatter'

class LongFormatter < Formatter
  def render
    total = "total #{@file_list.count_block}"
    body = render_body
    [total, *body].join("\n")
  end

  def render_body
    max_sizes = @file_list.research_max_size
    @file_list.file_details.map do |data|
      render_row(data, *max_sizes)
    end
  end

  def render_row(data, max_nlink, max_user, max_group, max_size)
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
