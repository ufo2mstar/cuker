require_relative 'abstract_writer'
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
      @active_sheet.add_row title_ary
    end

    def write_new_row row_ary
      super row_ary
      @log.debug "rxl write row: #{row_ary}"
      @active_sheet.add_row row_ary
    end

    def make_new_book name
      @log.debug "rxl make new sheet"
      #todo: dangit! handling this path naming properly
      file_name = "#{name.nil? ? super(name) : name}#{ext}"
      @sheets[file_name] = RubyXLSheet.new file_name
      @active_sheet = @sheets[file_name]
      file_name
    end

    def make_new_file name
      path = super name
      make_new_book name
    end

    def finishup

    end

    class RubyXLSheet < AbstractSheet
      def initialize file_name
        super file_name
        @log.info "Making new #{self.class} => #{file_name}"
        # @jira_file = File.open(file_name, "wb")

        @workbook = RubyXL::Parser.parse './simple_macro_template.xlsm'

        # workbook = RubyXL::Workbook.new
        @worksheets = @workbook.worksheets
        # workbook['test_id']
        @active_sheet = workbook[0]
        @active_sheet = workbook['Acceptance Tests']
      end

      def current_row
        @rows.size + 1
      end

      def add_row ary
        @rows << ary
      end

      alias :add_line :add_row

      # @return ary of rows
      def read_rows
        @rows
      end

      def finishup

      end
    end
  end
end