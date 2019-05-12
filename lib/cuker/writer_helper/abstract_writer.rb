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

  attr_accessor :sheets, :active_sheet
  attr_reader :out_dir

  def initialize output_loc = OUTPUT_DIR
    init_logger
    @out_dir = output_loc
    @log.debug "initing AbstractWriter @ #{@out_dir}"
    @sheets = {}
  end

  def make_new_sheet name = nil
    @log.debug "make new abstract sheet"
    name.nil? ? "Sheet_#{@sheets.size + 1}" : name
    # @sheets[name] = Sheet.new name
    # todo: file name collision handle
  end
end

class AbstractSheet
  attr_accessor :name, :rows

  def initialize name
    @name = name
    @rows = []
  end

  def current_row
    @rows.size + 1
  end

  def add_row ary
    @rows << ary
  end

  # @return ary of rows
  def read_rows
    @rows
  end
end