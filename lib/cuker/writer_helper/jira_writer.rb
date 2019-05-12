require_relative 'abstract_writer'

class JiraWriter < AbstractWriter
  def initialize
    @ext = '.txt'
    super
    @log.debug "initing #{self.class}"
  end

  def write_title title_ary
    super title_ary
    @log.debug "JW write title"
    @active_sheet.add_row title_ary
  end

  def write_new_row row_ary
    super row_ary
    @log.debug "JW write row"
    @active_sheet.add_row row_ary
  end

  def make_new_sheet name = nil
    @log.debug "JW make new sheet"
    path = super name
    @sheets[path] = JiraFile.new path, @ext
    @active_sheet = @sheets[path]
  end

  def make_file name
    super name
    make_new_sheet name
  end
end

class JiraFile < AbstractSheet
  def initialize path, ext
    file_name = "#{path}#{ext}"
    super file_name
    @csv_sheet = File.open(file_name, "wb")
  end

  def add_row row_ary
    super row_ary
    # @csv_sheet << ary
    File.open(@name, "ab") do |file|
      file << row_ary
    end
  end

  # @return ary of rows
  def read_rows
    @rows = File.read(@name)
  end

end