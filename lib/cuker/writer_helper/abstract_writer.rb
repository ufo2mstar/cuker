module Interface
  def method(name)
    define_method(name) {|*args|
      raise NotImplementedError.new("implemented interface method: '#{name}'")
    }
  end
end

module IWriter
  extend Interface
  method :initialize
  method :write_title
  method :write_new_row
end

class AbstractWriter
  include IWriter
  include LoggerSetup

  attr_accessor :ext
  attr_accessor :sheets, :active_sheet
  attr_reader :out_dir

  def initialize
    init_logger
    # @out_dir = output_path
    # FileUtils.mkdir_p(output_path) unless Dir.exist? output_path
    @log.debug "initing AbstractWriter"
    @active_sheet = nil
    @sheets = {}
  end

  def make_new_sheet name = nil
    file_name = name.nil? ? "Sheet_#{@sheets.size + 1}" : name
    @log.debug "make a new abstract sheet: #{file_name}"
    file_name
    # todo: file name collision handle
  end

  def make_file name
    @log.debug "make a new abstract file: #{name}"
  end
end

class AbstractSheet
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
    @log.error "argument not an array.. instead is a '#{ary.class}' -> '#{ary}'" unless ary.is_a? Array
    @rows << ary
  end

  # @return ary of rows
  def read_rows
    @rows
  end
end