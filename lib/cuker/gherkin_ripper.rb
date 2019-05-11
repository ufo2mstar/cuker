# == Gherkin Ripper
# does lexing and parsing (building a simple ParseTree for Cucumber Gherkins)
# adding a few support methods to ripping
#
module Cuker
  class GherkinRipper
    include LoggerSetup

    attr_accessor :location
    # attr_reader :features
    attr_accessor :features

    def initialize path = '*'
      init_logger
      @location = path
      @features = get_features @location
      @log.trace "Gherkin ripper running at #{path}"
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
end