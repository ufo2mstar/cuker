require_relative 'abstract_writer'

module Cuker
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
      #todo: dangit! handling this path naming properly
      file_name = "#{name.nil? ? super(name) : name}#{ext}"
      @sheets[file_name] = CsvSheet.new file_name
      @active_sheet = @sheets[file_name]
      file_name
    end

    def make_new_file name
      path = super name
      make_new_sheet name
    end
  end

  require 'csv'
# == CSV Sheet
# extends sheet to give csv read/write-ability
# {file:https://docs.ruby-lang.org/en/2.1.0/CSV.html CSV usage documentation}

  class CsvSheet < AbstractSheet
    def initialize file_name
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
end