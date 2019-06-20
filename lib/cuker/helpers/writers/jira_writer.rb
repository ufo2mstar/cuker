# require_relative 'abstract_writer'

module Cuker
  class JiraWriter < AbstractWriter
    def initialize
      @ext = '.txt'
      super
      @log.debug "initing #{self.class}"
    end

    def write_title title_line
      super title_line
      @log.debug "JW write title: #{title_line}"
      @active_file.add_line title_line
    end

    def write_new_row row_line
      super row_line
      @log.debug "JW write row: #{row_line}"
      @active_file.add_line row_line
    end

    def make_new_sheet name = nil
      @log.debug "JW make new sheet"
      path = super name
      path
    end

    def make_new_file name
      path = super name
      @book[path] = JiraFile.new path
      @active_file = @book[path]
      path
    end
  end

  class JiraFile < AbstractSheet
    def initialize file_name
      super file_name
      @log.info "Making new #{self.class} => #{file_name}"
      @jira_file = File.open(file_name, "wb")
      @jira_file.close
    end

    def add_line line
      super line
      @log.error "argument not a String.. instead is a '#{line.class}' -> '#{line}'" unless line.is_a? String
      File.open(@name, "ab") do |file|
        file << "#{line}\n"
      end
    end

    # @return ary of rows
    def read_rows
      @rows = File.read(@name)
    end

  end
end