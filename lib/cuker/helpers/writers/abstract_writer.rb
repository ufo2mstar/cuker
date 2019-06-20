module Cuker
  module IWriter
    extend Interface
    method :initialize
    method :write_title
    method :write_new_row

    method :make_new_file
    method :write_new_sheet
    method :finishup
  end

  class AbstractWriter
    include IWriter
    include LoggerSetup

    NoNewFileMadeError = Class.new IOError

    # File Extension
    attr_accessor :ext

    # Active file name
    attr_accessor :active_file_name

    attr_accessor :book, :active_file
    attr_reader :out_dir

    def initialize
      init_logger
      # @out_dir = output_path
      # FileUtils.mkdir_p(output_path) unless Dir.exist? output_path
      @log.debug "initing AbstractWriter"
      @active_file = nil
      @book = {}
    end

    def write_title data
      raise_unless_active_loc data
    end

    def write_new_row data
      raise_unless_active_loc data
    end

    def raise_unless_active_loc data
      raise NoNewFileMadeError.new "Please run 'make_new_file' before trying to write: '#{data}'" if @active_file.nil?
    end

    def make_new_sheet name = nil
      sheet = new_name name
      @log.debug "make a new abstract sheet: #{sheet}"
      sheet
      # todo: file name collision handle!!
    end

    def finishup
      @log.debug "closing up #{@name} file if needed"
    end

    def make_new_file name
      @log.debug "make a new abstract file: #{name}#{@ext}"
      make_name name
    end

    # @return [String] name with ext path added
    def make_name name
      "#{new_name name}#{@ext}"
    end

    def new_name name
      name.nil? ? "Sheet_#{@book.size + 1}" : name
    end
  end

  class AbstractFile
    include LoggerSetup
    attr_accessor :name, :rows

    def initialize name
      init_logger
      @name = name
      @rows = []
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
      @log.debug "closing up #{@name} file if needed"
    end
  end

end