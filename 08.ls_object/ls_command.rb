# frozen_string_literal: true

require './argument'
require './long_formatter'
require './short_formatter'

arg = Argument.new
file_list = FileList.new(arg.params, arg.pathname)
formatter = arg.params[:long_format] ? LongFormatter.new(file_list) : ShortFormatter.new(file_list)
puts formatter.run_ls
