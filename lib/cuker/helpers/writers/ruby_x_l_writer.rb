require_relative 'abstract_writer'

module Cuker
  class RubyXLWriter < AbstractWriter
    def initialize
      super
      @log.debug "initing #{self.class}"
    end

    def write_title title_ary
      @log.debug "Rxl write title"
      @active_sheet.add_row title_ary
    end

    def write_new_row row_ary
      @log.debug "Rxl write row"
      @active_sheet.add_row row_ary
    end

    def make_new_sheet name = nil
      @log.debug "Rxl make new sheet"
      path = super name
      @sheets[name] = RubyXLSheet.new path
    end

    def make_new_file name
      super name
    end

    class RubyXLSheet < AbstractSheet
      def initialize file_name
        super file_name
        @log.info "Making new #{self.class} => #{file_name}"
        # @jira_file = File.open(file_name, "wb")

        @workbook = RubyXL::Parser.parse './sample_template.xlsx'
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
    end
  end
end