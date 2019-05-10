require 'thor'

require 'require_all'
require_all 'lib/cuker/*.rb'

module GPHelper
  def self.dash_print(ary)
    # ary.each {|x| puts "  - '#{x}'"}
  end
end

class GherkinParserCmd < Thor

  GPTOOL = GherkinParser.new
  PRESET_LOCS = ['*', './*']

  # desc "hello NAME", "say hello to NAME"
  # def hello(name, from = nil)
  #   puts "from: #{from}" if from
  #   puts "Hello #{name}"
  # end

  desc "gp LOCATION", "parse all *.feature files in the given LOCATION"

  def gp loc = "../jira*/**/*"
    puts "running GPTOOL @ #{loc}"
  end

  desc "gpp", "parse all *.feature files in the preset locations: \n#{GPHelper.dash_print PRESET_LOCS}"

  def gpp
    puts "running GPTOOL @ #{PRESET_LOCS}"
  end


  desc "gpr LOCATION REPORT_FILE_NAME",
       "reports parsed results into REPORT_FILE_NAME for all *.feature files in the given LOCATION"

  def gpr loc = "../jira*/**/*", report_file_name = 'report'
    puts "running GPTOOL @ '#{loc}' '#{report_file_name}.xlsx'"
  end
end

# GherkinParserCmd.start(ARGV)
