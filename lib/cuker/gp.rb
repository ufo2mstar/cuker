require 'thor'

require 'require_all'
require_all 'lib/cuker/**/*.rb'
require_all 'lib/cuker/*.rb'

module Cuker
  module GPHelper
    def self.dash_print(ary)
      # ary.each {|x| puts "  - '#{x}'"}
    end
  end

  class GherkinParserCmd < Thor
    include LoggerSetup

    GPTOOL = GherkinParser.new
    PRESET_LOCS = ['*', './*']

    desc "gp LOCATION", "parse all *.feature files in the given LOCATION"

    def gp loc = "../jira*/**/*"
      init
      @log.warn "running GPTOOL @ #{loc}"
    end

    desc "gpp", "parse all *.feature files in the preset locations: \n#{GPHelper.dash_print PRESET_LOCS}"

    def gpp
      init
      @log.warn "running GPTOOL @ #{PRESET_LOCS}"
    end


    desc "gpr LOCATION REPORT_FILE_NAME",
         "reports parsed results into REPORT_FILE_NAME for all *.feature files in the given LOCATION"

    def gpr loc = "../jira*/**/*", report_file_name = 'report'
      init
      @log.warn "running GPTOOL @ '#{loc}' '#{report_file_name}.xlsx'"
    end


    private

    def init
      init_logger :warn
    end
  end

# GherkinParserCmd.start(ARGV)
end