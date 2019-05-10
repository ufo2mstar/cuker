require_relative 'abstract_writer'

class RubyXLWriter < AbstractWriter
  def initialize
    super
    @log.debug "initing #{self.class}"
    @active_sheet = make_new_sheet
  end

  def write_title title_ary
    @log.debug "write title"
    @active_sheet.add_row title_ary
  end

  def write_new_row row_ary
    @log.debug "write row"
    @active_sheet.add_row row_ary
  end

  def make_new_sheet name = nil
    @log.debug "make new sheet"
    name = super name
    path = File.join(@out_dir, name)
    @sheets[name] = RubyXLSheet.new path
  end

  class RubyXLSheet < AbstractSheet
    #todo: finish class
  end
end