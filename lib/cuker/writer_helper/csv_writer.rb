require_relative 'abstract_writer'

class CsvWriter < AbstractWriter
  def initialize output_loc
    super output_loc
    @log.debug "initing #{self.class}"
    @active_sheet = nil
  end

  def write_title title_ary
    @log.debug "csv write title"
    @active_sheet.add_row title_ary
  end

  def write_new_row row_ary
    @log.debug "csv write row"
    @active_sheet.add_row row_ary
  end

  def make_new_sheet name = nil
    @log.debug "csv make new sheet"
    name = super name
    # path = File.join(@out_dir, name)
    @sheets[name] = CsvSheet.new name
    @active_sheet = @sheets[name]
  end

  def make_file name
    make_new_sheet name
  end
end

require 'csv'
# == CSV Sheet
# extends sheet to give csv read/write-ability
# {file:https://docs.ruby-lang.org/en/2.1.0/CSV.html CSV usage documentation}

class CsvSheet < AbstractSheet
  def initialize path
    file_name = "#{path}.csv"
    super file_name
    @csv_sheet = CSV.open(file_name, "wb")
  end

  def add_row row_ary
    super row_ary
    # @csv_sheet << ary
    CSV.open(@name, "ab") do |csv|
      csv << row_ary
    end
  end

  # @return ary of rows
  def read_rows
    @rows = CSV.read(@name)
  end
end