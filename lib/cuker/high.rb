# require 'cuker'
# require 'highline'
#
# gpc = Cuker::CukerCmd.new
# cli = HighLine.new
#
# DEFAULT_REPORT_FILE_NAME = 'kod'
# DEFAULT_FEATURES_PATH = "../../features/uat/gcm/jira_stories/"
# DEFAULT_REPORT_PATH = './reports'
#
# def ask_for_input_location
#   loc = cli.ask "\nWant is your JIRA id:\n"
#   feat_path = File.join DEFAULT_FEATURES_PATH, loc
# end
#
# def ask_for_output_file_name
#   loc = cli.ask "\nWhere do you want to store thisid:\n"
#   feat_path = File.join DEFAULT_FEATURES_PATH, loc
# end
#
# def handle_call args
#   begin
#     feat_path = ask_for_input_location
#     yield feat_path, out_file
#   rescue Exception
#     puts "An Error occured\nplease contact v675166 for more details\n"
#   end
# end
#
# loop do
# # Menus:
#
#   cli.choose do |menu|
#     menu.prompt = "\n\nWhat report do you want to generate?\n"
#
#     menu.choice(:print_jira_text) {
#       feat_path = ask_for_input_location
#       file_name = "gpc.gpj feat_path, '.', DEFAULT_REPORT_FILE_NAME"
#       cli.say("Created Jira Text file @ #{file_name}") if file_name
#     }
#
#     menu.choice(:generate_csv_report) {
#       jira_id = cli.ask "\nWant is your JIRA id:\n"
#       feat_path = File.join DEFAULT_FEATURES_PATH, jira_id
#       file_name = "gpc.gpr DEFAULT_REPORT_FILE_NAME, feat_path, DEFAULT_REPORT_PATH"
#       cli.say("Created CSV file @ #{file_name}") if file_name
#     }
#
#     menu.choice(:generate_xlsx_report) {cli.say("Creating Jira Text @ {gpc.gpr}")}
#
#     menu.choice(:quit) {cli.say("Thank you for using Cuker!\nnow quitting"); exit}
#     menu.default = :quit
#   end
#
#   answer = cli.ask "\nWant to rerun? [or just hit enter to quit program]\n"
#   break if answer.empty?
#   puts "\n... rebooting ...\n\n"
# end
#
#
# # cli = HighLine.new
# # cli.choose do |menu|
# #   menu.shell = true
# #
# #   menu.choice(:load, text: 'Load a file',
# #               help: "Load a file using your favourite editor.")
# #   menu.choice(:save, help: "Save data in file.")
# #   menu.choice(:quit, help: "Exit program.")
# #
# #   menu.help("rules", "The rules of this system are as follows...")
# # end