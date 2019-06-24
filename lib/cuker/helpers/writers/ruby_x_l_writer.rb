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
      @log.trace "rxl write title: #{title_ary}"
      @active_file.add_row title_ary
    end

    def write_new_row row_ary
      super row_ary
      @log.trace "rxl write row: #{row_ary}"
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

    def write model, output_file_path
      file_name = make_new_file output_file_path
      model.data.each(&method(:write_new_row))
      finishup
      file_name
    end
  end

  class RubyXLFile < AbstractFile
    attr_accessor :workbook, :worksheets, :worksheet

    def initialize file_name

      premade = File.basename(file_name) =~ /xlsm/
      # premade = true
      # premade = false
      template_file_name = './lib/cuker/helpers/writers/simple_macro_template.xlsm'
      # template_file_name = './lib/cuker/helpers/writers/demo_file2.xlsm'
      @file_name = premade ? template_file_name : file_name

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