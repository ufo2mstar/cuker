require_relative 'log_utils'

# = Parse Gherkins into my mental models
#
# Init Parser and get to action on a given location
# @
class GherkinParser
  include LoggerSetup

  attr_accessor :location
  # attr_reader :features
  attr_accessor :features

  def initialize loc = '*'
    init_logger
    @location = loc
    @features = get_features @location
    @log.info "Parsed '.feature' files = #{@features.size}"
  end

  private

  # if you need to ignore any pattern of files, change this regex to match those patterns
  IGNORE_EXP = /^$/

  # dir glob for all feature files
  # @param location dir location of all the feature files
  def get_features(loc)
    FileHelper.get_files(loc, '.feature', IGNORE_EXP)
  end

end
class FileHelper
  def self.get_files loc, target_pattern, ignore_patterns
    Dir.glob("#{loc}/**/*#{target_pattern}").select {|x| x !~ ignore_patterns}
  end
end