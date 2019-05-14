require_relative 'abstract_writer'

class CsvWriter < AbstractWriter
  def initialize
    @ext = '.csv'
    super
    @log.debug "initing #{self.class}"
  end

  def write_title title_ary
    super title_ary
    @log.debug "csv write title"
    @active_sheet.add_row title_ary
  end

  def write_new_row row_ary
    super row_ary
    @log.debug "csv write row: #{row_ary}"
    @active_sheet.add_row row_ary
  end

  def make_new_sheet name
    @log.debug "csv make new sheet"
    path = super name
    @sheets[path] = CsvSheet.new path, @ext
    @active_sheet = @sheets[path]
  end

  def make_file name
    super name
    make_new_sheet name
  end
end

require 'csv'
# == CSV Sheet
# extends sheet to give csv read/write-ability
# {file:https://docs.ruby-lang.org/en/2.1.0/CSV.html CSV usage documentation}

class CsvSheet < AbstractSheet
  def initialize path, ext
    file_name = "#{path}#{ext}"
    super file_name
    @csv_sheet = CSV.open(file_name, "wb")
  end

  def add_row row_ary
    super row_ary
    @log.warn "argument not an array.. instead is a '#{row_ary.class}' -> '#{row_ary}'" unless row_ary.is_a? Array
    CSV.open(@name, "ab") do |csv|
      csv << row_ary
    end
  end

  # @return ary of rows
  def read_rows
    @rows = CSV.read(@name)
  end
end