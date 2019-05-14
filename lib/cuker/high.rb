# require 'cuker'
# require 'highline'
#
# CCC = Cuker::CukerCmd.new
# CLI = HighLine.new
#
# DEFAULT_REPORT_FILE_NAME = 'DEFAULT_REPORT_NAME'
# # DEFAULT_FEATURES_PATH = "../../features/"
# DEFAULT_FEATURES_PATH = "."
# # DEFAULT_REPORT_PATH = './reports'
#
# def ask_for_input_location
#   loc = CLI.ask "\nType your JIRA number:\n"
#   [File.join(DEFAULT_FEATURES_PATH, '**', loc), loc]
# end
#
# def ask_for_output_file_name default = DEFAULT_REPORT_FILE_NAME
#   # name = CLI.ask "\nType your report file name: \n[hit enter to use this default name => '#{default}']\n"
#   name = CLI.ask "\nHit enter to use this default name for your output file => '#{default}'\n[if not, please type in the name you want]\n"
#   name.empty? ? default : name
# end
#
# def handle_call preset
#   begin
#     feat_path, default_file_name = ask_for_input_location
#     report_name = ask_for_output_file_name("#{preset}_#{default_file_name.empty? ? DEFAULT_REPORT_FILE_NAME : default_file_name}")
#     file_name = CCC.report preset, report_name, feat_path
#     CLI.say("\n\nCreated '#{preset}' @ \n'#{file_name}' ... Enjoy!\n") if file_name
#   rescue Exception
#     puts "An Error occured while \nplease contact NarenSS (v675166) for more details\n"
#     puts e
#   end
# end
#
# def exit_message
#   CLI.say("\nThank you for using Cuker (a Gherkin Reporting Tool) :)\n
# Have Feature requests or Usage questions?
# Feel free to reach out to NarenSS (v675166)\n
# Have a very good day!")
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
#     menu.choice(:quit) { exit_message }
#     menu.default = :quit
#   end
#
#   answer = CLI.agree "\nWant to rerun? \n y [n]\n"
#   break unless answer
#   puts "\n... rebooting ...\n\n"
# end
#
# exit_message
