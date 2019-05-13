module IModel
  extend Interface
  method :initialize
  method :write_title
  method :write_new_row

  method :make_file
  method :write_new_sheet
end


class AbstractModel
  include LoggerSetup

  # @return [Array] writable rows of title
  #   Defaults to []
  attr_accessor :title

  # @return [Array] writable array of rows of data
  #   Defaults to []
  attr_accessor :data

  def initialize _model_input = []
    init_logger
    @title = []
    @data = []
  end

  def get_values_ary ary_of_hshs
    ary_of_hshs.map {|hsh| hsh.values}.flatten
  end

  def get_keys_ary ary_of_hshs
    ary_of_hshs.map {|hsh| hsh.keys}.flatten
  end

end