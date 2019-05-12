require 'rspec'
require 'ap'
require 'require_all'

require_all 'lib/**/*.rb'

# puts Dir.pwd+ "*"*80
OUTPUT_DIR = "reports/#{LOG_TIME_TODAY}"
FileUtils.mkdir_p(OUTPUT_DIR) unless Dir.exist? OUTPUT_DIR

REPORT_FILE_LOC = 'reports'
REPORT_FILE_NAME = 'demo'

FileNotRemoved = Class.new StandardError

def after_cleanup
  glob_str = File.join(REPORT_FILE_LOC, '**', "*#{REPORT_FILE_NAME}*")
  ans = Dir.glob(glob_str)
  old_count = ans.size
  return if old_count == 0

  # sleep 1
  FileUtils.rm_rf Dir.glob(glob_str)
  ans.each {|x| FileUtils.rm_rf x if File.exist? x}
  ans = Dir.glob(glob_str)
  new_count = ans.size
  # unless new_count < old_count
  #   puts "#{old_count} -> #{new_count}"
  #   raise FileNotRemoved.new("please see why the file #{ans} is not removed yet")
  # end
end

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html,
  # :json, CustomFormatterClass
  #
  # Alternative to prefacing describe as RSpec.describe
  config.expose_dsl_globally = true

  # https://relishapp.com/rspec/rspec-core/v/2-2/docs/hooks/before-and-after-hooks#define-before-and-after-blocks-in-configuration
  config.before(:all) do
    # puts "beforea all"
    # LoggerSetup.reset_appender_log_levels :warn
    # LoggerSetup.reset_appender_log_levels :error
    LoggerSetup.reset_appender_log_levels :fatal,:trace
  end
  config.after(:all) do
    # puts "after all"
    # LoggerSetup.reset_appender_log_levels :warn
    # todo: figure this mess out!! :( works when debugged, else not
    after_cleanup
  end
end


# From awesome_print spec_helper

# This matcher handles the normalization of objects to replace non deterministic
# parts (such as object IDs) with simple placeholder strings before doing a
# comparison with a given string. It's important that this method only matches
# a string which strictly conforms to the expected object ID format.
RSpec::Matchers.define :be_similar_to do |expected, options|
  match do |actual|
    options ||= {}
    @actual = normalize_object_id_strings(actual, options)
    values_match? expected, @actual
  end

  diffable
end

# Override the Object IDs with a placeholder so that we are only checking
# that an ID is present and not that it matches a certain value. This is
# necessary as the Object IDs are not deterministic.
def normalize_object_id_strings(str, options)
  str = str.gsub(/#<(.*?):0x[a-f\d]+/, '#<\1:placeholder_id') unless options[:skip_standard]
  str = str.gsub(/BSON::ObjectId\('[a-f\d]{24}'\)/, 'placeholder_bson_id') unless options[:skip_bson]
  str
end
