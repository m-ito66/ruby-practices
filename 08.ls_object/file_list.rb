# frozen_string_literal: true

require './file_detail'

class FileList
  def initialize(params, pathname)
    @reverse_flag = params[:reverse]
    pattern = pathname.join('*')
    dot_params = params[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    @paths = Dir.glob(*dot_params)
  end

  def sort_paths
    @reverse_flag ? @paths.sort.reverse : @paths.sort
  end

  def file_details
    @paths.map { |file_path| FileDetail.new(file_path) }
  end

  def research_max_size
    [
      file_details.map { |file_detail| file_detail.nlink.size }.max,
      file_details.map { |file_detail| file_detail.user.size }.max,
      file_details.map { |file_detail| file_detail.group.size }.max,
      file_details.map { |file_detail| file_detail.size.size }.max
    ]
  end

  def count_block
    file_details.sum(&:blocks)
  end
end
