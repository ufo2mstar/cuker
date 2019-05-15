require 'thor'

require 'require_all'
# require_all 'lib/cuker/**/*.rb'
# require_all 'lib/cuker/*.rb'
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

    CONSTS = []
    PRESETS = {
        :simple_csv => [CsvModel, CsvWriter],
        :simple_jira => [JiraModel, JiraWriter],
        :monospaced_jira => [JiraMonoModel, JiraWriter],
    }

    # desc "report PRESET_KEY [FEATURE_PATH [REPORT_PATH [REPORT_FILE_NAME [LOG_LEVEL]]]]",
    #      "reports parsed results into \nREPORT_PATH/REPORT_FILE_NAME \nfor all '*.feature' files in the given FEATURE_PATH\nSTDIO LOG_LEVEL adjustable\n"

    def report preset_key, feat_path = "../", report_file_name = 'sample_report', report_path = ".", log_level = :error
      init_logger log_level
      report_path = File.join report_path, 'reports', LOG_TIME_TODAY

      msg = "running '#{preset_key.to_s.upcase}' reporter @\n Feature Path: '#{feat_path}' \n Report Path => '#{report_path}' - '#{report_file_name}'\n"

      @log.info msg
      puts msg

      model, writer = PRESETS[preset_key]

      gr = GherkinRipper.new feat_path
      ast_map = gr.ast_map
      preset_model = model.new ast_map
      preset_writer = writer.new
      grr = GherkinReporter.new preset_writer, preset_model, report_path, report_file_name
      File.expand_path grr.write
    end

    private

    def init
      # todo: init things if needed
    end
  end

  # GherkinParserCmd.start(ARGV)
end