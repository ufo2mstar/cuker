# require 'thor'

require 'require_all'
# require_all 'lib/cuker/**/*.rb'
# require_all 'lib/cuker/*.rb'
require_rel '**/helpers/*.rb'
require_rel '**/*.rb'
require_rel '*.rb'


module Cuker
  # module GPHelper
  #   def self.dash_print(ary)
  #     # ary.each {|x| puts "  - '#{x}'"}
  #   end
  # end

  # class CukerCmd < Thor
  class CukerCmd
    include LoggerSetup

    PRODUCERS = {}
    PRODUCERS[:simple_csv] = [CsvModel, CsvWriter]
    PRODUCERS[:simple_jira] = [JiraModel, JiraWriter]
    PRODUCERS[:monospaced_jira] = [JiraMonoModel, JiraWriter]
    PRODUCERS[:jira_excel] = [RubyXLModel, RubyXLWriter]
    PRODUCERS[:summary_excel] = [SummaryXLModel, SummaryXLWriter]

    PRESETS = {}
    PRESETS[:jira_package] = [:simple_jira, :jira_excel]
    PRESETS[:jira_text] = [:simple_jira]
    PRESETS[:jira_excel] = [:jira_excel]
    PRESETS[:testsuite_summary] = [:summary_excel]


    # desc "report PRESET_KEY [FEATURE_PATH [REPORT_PATH [REPORT_FILE_NAME [LOG_LEVEL]]]]",
    #      "reports parsed results into \nREPORT_PATH/REPORT_FILE_NAME \nfor all '*.feature' files in the given FEATURE_PATH\nSTDIO LOG_LEVEL adjustable\n"

    def report preset_key,
               feat_path = "../",
               report_file_name = 'sample_report',
               report_path_input = ".",
               special_tags_list = [
                   "@uat_done",
                   "@cmo_done",
                   "@tech_done",
                   "@test_done",
               ],
               log_level = :info

      init_logger log_level
      output_files = []
      producers = PRESETS[preset_key]

      @log.info "Using preset: #{preset_key} => #{producers}"
      gr = GherkinRipper.new feat_path
      ast_map = gr.ast_map

      producers.each do |producer|
        report_path = File.join report_path_input, 'reports', LOG_TIME_TODAY
        msg = "producing '#{producer.to_s.upcase}' report\t @ Report Path => '#{report_path}' - '#{report_file_name}' \t for Feature Files @ '#{feat_path}'\n"

        @log.info msg
        puts msg
        model, writer = PRODUCERS[producer]

        preset_model = model == SummaryXLModel ? model.new(ast_map, special_tags_list) : model.new(ast_map)
        preset_writer = writer.new
        grr = GherkinReporter.new preset_writer, preset_model, report_path, report_file_name

        output_files << File.expand_path(grr.write)
      end
      output_files
    end

    private

    def init
      # todo: init things if needed
    end
  end

  # GherkinParserCmd.start(ARGV)
end