require_relative 'log_utils'
# require 'writeexcel'

#= Write to Reports
#
# to write out all your parsed gherkins by tags etc..
# uses gem 'writeexcel'
class GherkinReportWriter
  include LoggerSetup

  attr_accessor :file_name, :workbook

  def initialize(loc, file_name = LOG_TIME_NOW)
    init_logger
    # extension = '.xls'
    extension = '.csv' # bad formats

    FileUtils.mkdir_p(loc) unless Dir.exist? loc

    @file_name = File.join(loc, (file_name + extension))
    @workbook = setup_report_file @file_name
    @item_number = 1
    @log.info "Creating report file => #{@file_name}"
    @workbook.close
  end

  def add_feature_row(feature)
    @log.debug "add_feature_row => #{feature}"
  end

  private

  def setup_report_file output_file_name
    states = %w[OH, WI, NY, SA]
    col_list = [:ignore, :mock, :run, :defect, :other]

    # output_file = "scen_UAT-reg_done_#{Time.now.strftime '%F_%H-%M-%S'}.xls"
    # output_file = name
    title_hai = ["Sl.No;4", "Type;4", "Title;60", states.map {|a| a + ";2"}, col_list.map {|a| "#{a};10"}, "Feature;10", "S.no;3", "File"].flatten

    File.open(output_file_name,'wb')
    # workbook = WriteExcel.new(output_file_name)
    # worksheet = workbook.add_worksheet
    #
    # @format = workbook.add_format(:size => 10, :bold => 1); @format.set_align('center') #format.set_bold
    # @state_f = workbook.add_format(:size => 8, :align => "center") #@state_f.set_align('center')
    #
    #
    # worksheet.write('A1', title_hai.map {|itr| itr.split(";")[0]}, @format)
    # title_hai.each_with_index do |itr, i|
    #   worksheet.set_column(i, i, itr.split(";")[1].to_i) if itr.split(";")[1]
    # end
    # workbook
  end

  def basic_write
    itr = 0
    $feat_stuff = {}

    col_recog = title_hai.map {|each| each.split(";")[0].downcase}
    # col_list =[:cit, :special, :delta, :rtc, :other]
    # col_list =$col_list

    $arr.each {|each_scen_tag|
      scen_info = each_scen_tag[0]
      ($feat_tags = scen_info; itr += 1; next) if itr == 0

      worksheet.write(@item_number, 0, @item_number, @format)
      worksheet.write(@item_number, 1, scen_info[:S_type][0].gsub(/cenario|utline/, ""))
      worksheet.write(@item_number, 2, scen_info[:S_title][0].to_s.force_encoding("UTF-8"))

      scen_info[:state].each do |st|
        worksheet.write(@item_number, col_recog.index(st.downcase), st, @state_f)
        #worksheet.write(@exc_no, 3+state_list[st].to_i, st, @state_f)
        #worksheet.write(@exc_no, 3+state_list[st].to_i, "X",@state_f)
      end
      col_list.each {|key| worksheet.write(@item_number, col_recog.index(key.to_s), scen_info[key].join(","))}
      worksheet.write(@item_number, title_hai.size - 3, $feat_tags[:S_title])
      worksheet.write(@item_number, title_hai.size - 2, itr, workbook.add_format(:size => 8, :align => "center"))
      worksheet.write(@item_number, title_hai.size - 1, file.gsub("features/scenarios", ""))

      @item_number += 1; itr += 1
    }
  end

end
