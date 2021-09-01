# frozen_string_literal: true

require './file_detail'

class FileList
  attr_reader :paths

  def initialize(params, pathname)
    pattern = pathname.join('*')
    dot_params = params[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    @paths = Dir.glob(*dot_params).sort
  end
end
