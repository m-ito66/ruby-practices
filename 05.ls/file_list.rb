#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'pathname'
require 'optparse'
require 'byebug'

require './format'
include Format

class FileList
  attr_reader :paths
  def initialize(params, pathname)
    pattern = pathname.join('*')
    dot_params = params[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    @paths = Dir.glob(*dot_params).sort
    params[:reverse] ? @paths.reverse! : @paths
  end
end
