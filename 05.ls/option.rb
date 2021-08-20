#!/usr/bin/env ruby
# frozen_string_literal: true

require 'file_list'

class Option
  require 'io/console'
  require 'optparse'
  require 'pathname'

  require './lib/ls_command'

  opt = OptionParser.new

  params = { long_format: false, reverse: false, dot_match: false }
  opt.on('-l') { |v| params[:long_format] = v }
  opt.on('-r') { |v| params[:reverse] = v }
  opt.on('-a') { |v| params[:dot_match] = v }
  opt.parse!(ARGV)
  path = ARGV[0] || '.'
  pathname = Pathname(path)

  puts run_ls(pathname, **params)
end