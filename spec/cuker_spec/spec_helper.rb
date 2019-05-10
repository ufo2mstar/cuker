require 'rspec'
require 'ap'
require 'require_all'
# require_all '../lib/*'
require_all 'lib/**/*.rb'


OUTPUT_DIR = "../../reports/#{LOG_TIME_TODAY}"
# Dir.mkdir(OUTPUT_DIR) unless Dir.exist? OUTPUT_DIR
FileUtils.mkdir_p(OUTPUT_DIR) unless Dir.exist? OUTPUT_DIR

# describe 'fixture setup' do
#   after(:all) do
#     puts "Running Cleanup!!"
#   end
# end

reset_appender_log_levels :warn


RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html,
  # :json, CustomFormatterClass
  #

  # https://relishapp.com/rspec/rspec-core/v/2-2/docs/hooks/before-and-after-hooks#define-before-and-after-blocks-in-configuration
  config.before(:all) do
    # puts "beforea all"
  end
  config.after(:all) do
    # puts "after all"
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
