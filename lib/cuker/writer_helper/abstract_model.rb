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
    ary_of_hshs.map(&:values).flatten
  end

  def get_keys_ary ary_of_hshs
    ary_of_hshs.map(&:keys).flatten
  end

#   utility methods
# used by any model

  def name_merge hsh
    str = ""
    @log.warn "name merge for #{hsh}"
    str += hsh[:name].strip.force_encoding("UTF-8") if hsh[:name]
    str += " - #{hsh[:description].strip.force_encoding("UTF-8")}" if hsh[:description]
    str
  end


  def union feat_tags, tags
    (feat_tags.to_set | tags.to_set).to_a # union
  end

  def surround ary, sep
    # "#{sep}#{ary.is_a?(Array)? ary.join(sep) : ary}#{sep}"
    # "#{sep}#{ary.join(sep)}#{sep}"
    simple_surround ary.join(sep), sep
  end

  def simple_surround item, sep
    "#{sep}#{item}#{sep}"
  end

  # def padded_surround item, sep, pad
  #   "#{sep}#{pad}#{item}#{pad}#{sep}"
  # end

  def get_tags(hsh)
    if hsh[:tags] and hsh[:tags].any?
      hsh[:tags].map {|tag| tag[:name]}
    else
      @log.warn "No Tags found in #{hsh[:keyword]} @ #{@file_path}"
      []
    end
  end

end