require 'rspec'
require 'ap'
require 'require_all'
require 'yaml'

require_all 'lib/**/*.rb'

# puts Dir.pwd+ "*"*80
OUTPUT_DIR = "reports/#{LOG_TIME_TODAY}"
FileUtils.mkdir_p(OUTPUT_DIR) unless Dir.exist? OUTPUT_DIR

REPORT_FILE_LOC = 'reports'
TESTDATA_LOC = 'spec/cuker_spec/testdata'
REPORT_FILE_NAME = 'demo'

FileNotRemoved = Class.new StandardError

module CukerSpecHelper
  extend self

  PICKLER_TYPE = :yaml # for data (arrays, hashes, etc)
  # PICKLER_TYPE = :marshal # for objects

  # Cleanup file names with the name #{REPORT_FILE_NAME}
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
    # todo: fix this fail, which only cleans up during the subsequent run
    unless new_count < old_count
      puts "#{old_count} -> #{new_count}"
      raise FileNotRemoved.new("please see why the file #{ans} is not removed yet")
    end
  end

  def debug_show ary
    spec_error_debug = true # use if you want to see file printouts
    spec_error_debug = false # default
    if spec_error_debug
      p
      p ary
      p
      puts ary.join "\n"
    end
  end

  def snapshot_store data, snapshot_file_name, type = PICKLER_TYPE # objects can be pickled with :marshal
    snapshot_file_path = File.join(TESTDATA_LOC, 'result_snapshots', "#{snapshot_file_name}.yml")

    if type == :marshal
      # marshal method
      dump = Marshal.dump data
      File.write(snapshot_file_path, dump)
      res = Marshal.load File.read snapshot_file_path
    elsif type == :yaml
      # YAML method
      dump = data.to_yaml
      # File.open(snapshot_file_path, "w") {|file| file.write(dump)}
      File.write(snapshot_file_path, dump)
      res = YAML.load(File.read(snapshot_file_path))
    else
      raise ScriptError.new "enter one of these values :marshal, :yaml"
    end

    puts res
    puts "successfully stored in '#{snapshot_file_path}' - \n=> #{data}\n=> #{res}}"
    # exit
  end

  def get_file snapshot_partial, path
    glob_str = File.join(path, "*#{snapshot_partial}*")
    snapshots = Dir.glob(glob_str)
    if snapshots.size < 1
      raise NotImplementedError.new "no snapshot file found: '#{glob_str}'"
    elsif snapshots.size > 1
      raise IOError.new "too many snapshot files found: '#{snapshot_partial}' has - \n#{snapshots.join "\n"}"
    else
      yield snapshots.first
    end
  end

  def report_snapshot_retrieve snapshot_partial
    get_file(snapshot_partial, REPORT_FILE_LOC) do |file_name|
      # File.read file_name
      file_name
    end
  end

  def snapshot_retrieve snapshot_partial, type = PICKLER_TYPE # objects can be pickled with :marshal
    get_file(snapshot_partial, File.join(TESTDATA_LOC, 'result_snapshots')) do |file_name|
      dump = File.read file_name
      if type == :marshal
        Marshal.load dump
      elsif type == :yaml
        YAML.load dump
      else
        raise ScriptError.new "enter one of these values :marshal, :yaml"
      end
    end
  end

  def self.compare_arys(res_rows, exp_rows)
    RSpec.describe do
      it 'res_rows === exp_rows' do
        expect(res_rows.join "\n").to be_similar_to exp_rows.join "\n"
      end
    end
  end

  def self.snapshot_compare(rows, snapshot_name)
    CukerSpecHelper.debug_show(rows)
    begin
      exp_rows = CukerSpecHelper.snapshot_retrieve snapshot_name
      # CukerSpecHelper.compare_arys rows, exp_rows # suddenly not working for some reason!
      return [rows, exp_rows]
    rescue NotImplementedError => e
      #todo: make a better handle for snapshotting
      warn "\n#{e.message}\n... So creating a new snapshot => '#{snapshot_name}'"
      CukerSpecHelper.snapshot_store(rows, snapshot_name)
      # retry # having issues with retest scripts
      return CukerSpecHelper.snapshot_compare(rows, snapshot_name)
    end
    [nil, nil]
  end
end

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  # config.formatter = :documentation # :progress, :html,
  config.formatter = :progress #
  # config.formatter = :p #
  # config.formatter = :html #
  # :json, CustomFormatterClass
  #
  # Alternative to prefacing describe as RSpec.describe
  config.expose_dsl_globally = true

  # https://relishapp.com/rspec/rspec-core/v/2-2/docs/hooks/before-and-after-hooks#define-before-and-after-blocks-in-configuration
  config.before(:all) do
    # puts "beforea all"
    # LoggerSetup.reset_appender_log_levels :warn
    # LoggerSetup.reset_appender_log_levels :error
    # LoggerSetup.reset_appender_log_levels :fatal, :info
    # LoggerSetup.reset_appender_log_levels :info, :trace

    # LoggerSetup.reset_appender_log_levels :warn, :debug
    LoggerSetup.reset_appender_log_levels :fatal, :info
  end
  config.after(:all) do
    # puts "after all"
    # LoggerSetup.reset_appender_log_levels :warn
    # todo: figure this mess out!! :( works when debugged, else not

    CukerSpecHelper.after_cleanup
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
