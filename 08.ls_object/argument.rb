# frozen_string_literal: true

require 'optparse'
require 'pathname'
require './formatter'

class Argument
  attr_reader :params, :pathname

  def initialize
    @params = { long_format: false, reverse: false, dot_match: false }

    opt = OptionParser.new
    opt.on('-l') { |v| @params[:long_format] = v }
    opt.on('-r') { |v| @params[:reverse] = v }
    opt.on('-a') { |v| @params[:dot_match] = v }
    opt.parse!(ARGV)
    path = ARGV[0] || '.'
    @pathname = Pathname(path)
  end
end
