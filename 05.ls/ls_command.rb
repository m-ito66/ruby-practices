# frozen_string_literal: true

require './argument'

arg = Argument.new
formatter = Formatter.new(arg.params, arg.pathname)
puts formatter.run_ls
