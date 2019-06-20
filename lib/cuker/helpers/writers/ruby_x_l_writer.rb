require_relative 'abstract_writer'
require 'rubyXL'
require 'rubyXL/convenience_methods'

module Cuker
  class RubyXLWriter < AbstractWriter
    def initialize
      @ext = '.xlsm'
      super
      @log.debug "initing #{self.class}"
    end

    def write_title title_ary
      super title_ary
      @log.debug "rxl write title"
      @active_file.add_row title_ary
    end

    def write_new_row row_ary
      super row_ary
      @log.debug "rxl write row: #{row_ary}"
      @active_file.add_row row_ary
    end

    def make_new_book name
      @log.debug "rxl make new sheet"
      #todo: dangit! handling this path naming properly
      file_name = "#{name.nil? ? super(name) : name}#{ext}"
      @book[file_name] = RubyXLFile.new file_name
      @active_file = @book[file_name]
      file_name
    end

    def make_new_file name
      path = super name
      finishup
      make_new_book name
    end

    def finishup
      @active_file.finishup if @active_file
    end
  end

  class RubyXLFile < AbstractFile
    def initialize file_name
      super file_name
      @file_name = file_name
      @log.info "Making new #{self.class} => #{file_name}"

      @workbook = RubyXL::Parser.parse './lib/cuker/helpers/writers/simple_macro_template.xlsm'
      # workbook = RubyXL::Workbook.new

      @worksheets = @workbook.worksheets

      # todo: delete sheet convenienve method
      # @workbook['test_id'].delete
      # delete_sheet 'null'
      delete_sheet 'test_id'

      # @active_sheet = @workbook[0]
      @active_sheet = @workbook['Acceptance Tests']
      @rows = @active_sheet.sheet_data.rows
    end

    def delete_sheet sheet_name
      sheet_index = @workbook.worksheets.index {|x| x.sheet_name == sheet_name}
      if sheet_index
        @workbook.worksheets.delete_at(sheet_index)
      else
        @log.error "no sheet named '#{sheet_name}' found.. available sheets []"
      end
    end

    def current_row
      @rows.size + 1
    end

    def add_row ary
      super ary

    end

    alias :add_line :add_row

    # @return ary of rows
    def read_rows
      @rows
    end

    def finishup
      # @workbook.write("#{@name}")
      @workbook.write("#{@file_name}") if @workbook
    end
  end
end