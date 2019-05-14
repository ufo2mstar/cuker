# require 'cuker'
# require 'highline'
#
# CCC = Cuker::CukerCmd.new
# CLI = HighLine.new
#
# DEFAULT_REPORT_FILE_NAME = 'DEFAULT_REPORT_NAME'
# # DEFAULT_FEATURES_PATH = "../../features/uat/gcm/jira_stories/"
# DEFAULT_FEATURES_PATH = "."
# # DEFAULT_REPORT_PATH = './reports'
#
# def ask_for_input_location
#   loc = CLI.ask "\nType your JIRA number:\n"
#   File.join DEFAULT_FEATURES_PATH, '**', loc
# end
#
# def ask_for_output_file_name
#   name = CLI.ask "\nType your report file name: \n[hit enter to use default name => '#{DEFAULT_REPORT_FILE_NAME}']\n"
#   name.empty? ? DEFAULT_REPORT_FILE_NAME : name
# end
#
# def handle_call preset
#   begin
#     feat_path = ask_for_input_location
#     report_name = ask_for_output_file_name
#     file_name = CCC.report preset, report_name, feat_path
#     CLI.say("\n\nCreated '#{preset}' @ '#{file_name}' ... Enjoy!\n") if file_name
#   rescue Exception
#     puts "An Error occured\nplease contact NarenSS (v675166) for more details\n"
#     puts e
#   end
# end
#
# def exit_message
#   CLI.say("Thank you for using Cuker :)\nFeel free to reach out to NarenSS (v675166) for any feature request\nHave a very good day!")
#   exit
# end
#
# loop do
# # Menus:
#   CLI.say("\nREPORT_NUMBERS:\n")
#   CLI.choose do |menu|
#     menu.prompt = "\n\nType the REPORT_NUMBER you want to generate?\n"
#
#     presets = Cuker::CukerCmd::PRESETS
#
#     presets.keys.each do |option|
#       menu.choice(option) do
#         handle_call option
#       end
#     end
#
#     menu.choice(:quit) {exit_message}
#     menu.default = :quit
#   end
#
#   answer = CLI.ask "\nWant to rerun? \n[ type anything and hit enter to rerun\nor just hit enter to quit this program ]\n"
#   break if answer.empty?
#   puts "\n... rebooting ...\n\n"
# end
#
# exit_message