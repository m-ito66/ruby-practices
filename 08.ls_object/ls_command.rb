# frozen_string_literal: true

require './argument'

arg = Argument.new
file_list = FileList.new(arg.params, arg.pathname)
formatter = Formatter.new(file_list, arg.params)
puts arg.params[:long_format] ? formatter.ls_long : formatter.ls_short
