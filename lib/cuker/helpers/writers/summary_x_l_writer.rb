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

  end

  class RubyXLFile < AbstractFile
    attr_accessor :workbook, :worksheets, :worksheet

    def initialize file_name, template_file_name

      premade = File.basename(file_name) =~ /xlsm/
      # premade = true
      # premade = false
      # template_file_name = "simple_macro_template.xlsm"
      template_file_path = File.join File.dirname(__FILE__), template_file_name
      # template_file_name = './lib/cuker/helpers/writers/simple_macro_template.xlsm'
      # template_file_name = './lib/cuker/helpers/writers/demo_file2.xlsm'
      @file_name = premade ? template_file_path : file_name

      super @file_name
      @log.debug "Making new #{self.class} => #{@file_name}"

      @workbook = premade ? RubyXL::Parser.parse(@file_name) : RubyXL::Workbook.new
      # @workbook.add_worksheet('Acceptance Tests')
      # @workbook[0].sheet_name = 'Acceptance Tests'

      @worksheets = @workbook.worksheets

      # todo: delete sheet convenienve method
      # @workbook['test_id'].delete

      # delete_sheet 'null'
      locate_sheet 'test_id'

      # @worksheet = @workbook[0]
      @worksheet = @workbook['Acceptance Tests raw']


      @rows = sheet_rows.dup # starting Row
      @offset = 0 # starting Col

      # inserting a blank cell to make sure title format is not being copied
      @worksheet.add_cell(@rows.size, @offset, ' ')

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
      super ary
      row, col = current_row, current_col
      worksheet.insert_row(row)
      ary.each do |val|
        worksheet.insert_cell(row, col, val.to_s)
        col += 1
      end

      link_sheet_name = "#{ary[0]} results"
      workbook.add_worksheet(link_sheet_name)
      # back_link_value = @link_sheet[0][0].value
      # back_link_formula = @link_sheet[0][0].formula
      # @workbook[link_sheet_name].add_cell(0, 0, back_link_value, back_link_formula)
      # workbook.worksheets <<
      # (link_sheet_name)

      @log.trace workbook.worksheets.map(&:sheet_name)
      # @log.debug sheet_rows
      # @log.debug worksheet.rows
    end

    alias :add_line :add_row

    # @return ary of rows
    def sheet_rows
      worksheet.sheet_data.rows
    end

    def finishup
      # @workbook.write("#{@name}")
      @workbook.worksheets.delete_at(locate_sheet 'test_id') if locate_sheet 'test_id'
      @workbook.write("#{@file_name}") if @workbook
    end
  end
end