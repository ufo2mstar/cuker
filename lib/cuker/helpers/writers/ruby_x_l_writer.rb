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
      end

    end
  end
end