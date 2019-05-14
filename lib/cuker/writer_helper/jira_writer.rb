require_relative 'abstract_writer'

class JiraWriter < AbstractWriter
  def initialize
    @ext = '.txt'
    super
    @log.debug "initing #{self.class}"
  end

  def write_title title_line
    super title_line
    @log.debug "JW write title"
    @active_sheet.add_line title_line
  end

  def write_new_row row_line
    super row_line
    @log.debug "JW write row"
    @active_sheet.add_line row_line
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

  def add_line line
    super line
    @log.warn "argument not a String.. instead is a '#{line.class}' -> '#{line}'" unless line.is_a? String
    File.open(@name, "ab") do |file|
      file << "#{line}\n"
    end
  end

  # @return ary of rows
  def read_rows
    @rows = File.read(@name)
  end

end