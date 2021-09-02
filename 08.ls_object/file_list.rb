# frozen_string_literal: true

require './file_detail'

class FileList
  attr_reader :paths

  def initialize(params, pathname)
    pattern = pathname.join('*')
    dot_params = params[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    @paths = params[:reverse] ? Dir.glob(*dot_params).sort.reverse : Dir.glob(*dot_params).sort
  end

  def self.collect_details(paths)
    paths.map do |file_path|
      FileDetail.new(file_path)
    end
  end

  def self.research_max_size(file_details)
    [
      file_details.map { |file_detail| file_detail.nlink.size }.max,
      file_details.map { |file_detail| file_detail.user.size }.max,
      file_details.map { |file_detail| file_detail.group.size }.max,
      file_details.map { |file_detail| file_detail.size.size }.max
    ]
  end
end
