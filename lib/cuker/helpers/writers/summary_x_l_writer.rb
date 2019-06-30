require_relative 'abstract_writer'
require 'rubyXL'
require 'rubyXL/convenience_methods'

module Cuker
  class SummaryXLWriter < RubyXLWriter
    def initialize
      # @ext = '.xlsm'
      super
      @template_file_name = "template_excel_summary.xlsm"
      @log.debug "initing #{self.class}"
    end

    def make_new_book name
      @log.debug "summary rxl make new sheet"
      #todo: dangit! handling this path naming properly
      file_name = "#{name.nil? ? super(name) : name}#{ext}"
      @book[file_name] = SummaryRubyXLFile.new file_name, @template_file_name
      @active_file = @book[file_name]
      file_name
    end

    def write model, output_file_path
      file_name = make_new_file output_file_path
      write_title model.title
      model.data.each {|row| write_new_row row}
      finishup
      file_name
    end
  end

  class SummaryRubyXLFile < RubyXLFile
    attr_accessor :workbook, :worksheets, :worksheet

    def initialize file_name, template_file_name

      premade = File.basename(file_name) =~ /xlsm/
      template_file_path = File.join File.dirname(__FILE__), template_file_name
      @file_name = premade ? template_file_path : file_name

      # super @file_name #replaced below
      init_logger
      @name = file_name
      @rows = []

      @log.debug "Making new #{self.class} => #{@file_name}"

      @workbook = premade ? RubyXL::Parser.parse(@file_name) : RubyXL::Workbook.new

      @worksheets = @workbook.worksheets
      @worksheet = @workbook['Feature Summary raw']

      @rows = sheet_rows.dup # starting Row
      @offset = 0 # starting Col

      @file_name = file_name
    end

    def locate_sheet sheet_name
      sheet_index = @workbook.worksheets.index {|x| x.sheet_name == sheet_name}
      @link_sheet = @workbook.worksheets[sheet_index]
      if sheet_index
        @log.debug "located sheet #{sheet_name} @location #{sheet_index}"
        # @workbook.worksheets.delete_at(sheet_index)
        sheet_index
      else
        @log.error "no sheet named '#{sheet_name}' found.. available sheets []"
        nil
      end
    end

    def current_row
      rows.size - 1
    end

    def current_col
      @offset
    end

    def add_row ary
      # super ary
      @rows << ary

      row, col = current_row, current_col
      worksheet.insert_row(row)
      ary.each do |val|
        worksheet.insert_cell(row, col, val.to_s)
        col += 1
      end

      @log.trace workbook.worksheets.map(&:sheet_name)
    end

    alias :add_line :add_row

  end
end