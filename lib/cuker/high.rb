# require 'cuker'
# require 'highline'
#
# CCC = Cuker::CukerCmd.new
# CLI = HighLine.new
#
# DEFAULT_REPORT_FILE_NAME = 'DEFAULT_REPORT_NAME'
# DEFAULT_FEATURES_PATH = "../../features/"
# # DEFAULT_FEATURES_PATH = "."
# # DEFAULT_REPORT_PATH = './reports'
#
# JIRA_FILE_HEADER = "\n----\n \nh2. *+Acceptance Test:+*\n\n"
#
# def ask_for_input_location
#   loc = CLI.ask "\nType your JIRA number:\n"
#   [File.join(DEFAULT_FEATURES_PATH, '**', loc), loc]
# end
#
# def ask_for_output_file_name default = DEFAULT_REPORT_FILE_NAME
#   # name = CLI.ask "\nType your report file name: \n[hit enter to use this default name => '#{default}']\n"
#   puts
#   name = ""
#   # name = CLI.ask "\n'#{default}' <= Use this 'Default Name' for your output file?\n[else, please type in the name you want]\n"
#   name.empty? ? default : name
# end
#
# # https://www.ruby-forum.com/t/how-to-append-some-data-at-the-beginning-of-a-file/112910/7
# def file_prepend file_path, str
#   temp_path = "#{file_path}.txt"
#   newfile = File.new(temp_path, "w")
#   newfile.puts str
#
#   File.open(file_path, "r+") do |f|
#     f.each_line {|line| newfile.puts line}
#   end
#
#   newfile.close
#
#   #File.delete(file_path)
#   #File.rename(temp_path, file_path)
#   temp_path
# end
#
#
# def handle_call preset
#   begin
#     feat_path, default_file_name = ask_for_input_location
#     report_name = ask_for_output_file_name("#{preset}_#{default_file_name.empty? ? DEFAULT_REPORT_FILE_NAME : default_file_name}")
#     file_name = CCC.report preset, feat_path, report_name
#     file_prepend file_name, JIRA_FILE_HEADER
#     CLI.say("\n\nCreated '#{preset}' @ \n'#{file_name}' ... Enjoy!\n") if file_name
#   rescue Exception => e
#     pad_str = '!' * 80
#     puts "\n\n#{pad_str}\nAn Error occured while running the report\nplease contact NarenSS (v675166) for more details\n#{pad_str}\n\n"
#     raise e
#   end
# end
#
# def exit_message
#   pad_str = '*' * 80
#   CLI.say("\n#{pad_str}\nThank you for using Cuker (a Gherkin Reporting Tool) :)\n
#  Have Feature requests or Usage questions?
#  Feel free to reach out to NarenSS (v675166)\n
#  Have a very good day!\n#{pad_str}\n")
#   exit
# end
#
# loop do
#   # Menus:
#   CLI.say("\nREPORT_NUMBERS:\n")
#   CLI.choose do |menu|
#     menu.prompt = "\n\nType the REPORT_NUMBER you want to generate?\n"
#
#     presets = Cuker::CukerCmd::PRESETS
#
#     presets.keys.each do |option|
#       menu.choice(option) do
#         handle_call option
#         exit_message
#       end
#     end
#
#     menu.choice(:quit) {exit_message}
#     menu.default = :quit
#   end
#
#   answer = CLI.agree "\nWant to run a new one? \n y [n]\n"
#   break unless answer
#   puts "\n... rebooting ...\n\n"
# end
#
# exit_message