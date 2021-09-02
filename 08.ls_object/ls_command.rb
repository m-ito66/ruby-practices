# frozen_string_literal: true

require './argument'
require './long_formatter'
require './short_formatter'

arg = Argument.new
file_paths = FileList.new(arg.params, arg.pathname).paths
formatter = arg.params[:long_format] ? LongFormatter.new(file_paths) : ShortFormatter.new(file_paths)
puts formatter.run_ls
