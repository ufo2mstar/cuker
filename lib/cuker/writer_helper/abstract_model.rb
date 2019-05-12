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
    ary_of_hshs.map {|hsh| hsh.values.first}
  end

  def get_keys_ary ary_of_hshs
    ary_of_hshs.map {|hsh| hsh.keys.first}
  end

end