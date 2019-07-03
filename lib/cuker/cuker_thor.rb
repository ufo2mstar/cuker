# require 'thor'
# require 'require_all'
#
# # require_all 'lib/cuker/**/*.rb'
# # require_all 'lib/cuker/*.rb'
#
# require_rel '**/helpers/*.rb'
# require_rel '**/*.rb'
# require_rel '*.rb'
#
#
# module Cuker
#   module GPHelper
#     def self.dash_print(ary)
#       ary.each {|x| puts "  - '#{x}'"}
#     end
#   end
#
#   class CukerCmd < Thor
#     desc "report PRESET_KEY [FEATURE_PATH [REPORT_PATH [REPORT_FILE_NAME [LOG_LEVEL]]]]",
#          "reports parsed results into \nREPORT_PATH/REPORT_FILE_NAME \nfor all '*.feature' files in the given FEATURE_PATH\nSTDIO LOG_LEVEL adjustable\n"
#     def cuker
#
#     end
#
#   end
#
#   GherkinParserCmd.start(ARGV)
# end