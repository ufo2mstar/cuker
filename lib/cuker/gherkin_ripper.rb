require_relative './helper/gherkin_helper'
# require 'gherkin/parser'
# require 'gherkin/token_scanner'
# require 'gherkin/token_matcher'
# require 'gherkin/ast_builder'
# require 'gherkin/errors'


# == Gherkin Ripper
# does lexing and parsing (building a simple ParseTree for Cucumber Gherkins)
# adding a few support methods to ripping
#
module Cuker

  class GherkinRipper
    include Gherkin
    include LoggerSetup

    attr_accessor :location
    # attr_reader :features
    attr_accessor :features, :ast_map

    def initialize path = '*'
      init_logger
      @location = path
      @features = get_features @location
      @log.trace "Gherkin ripper running at #{path}"

      @parser = Gherkin::Parser.new
      @ast_map = parse_all

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

    def parse_all
      parse_hsh = {}
      @features.each do |feat|
        feature_text = File.read(feat)
        scanner = TokenScanner.new(feature_text)
        ast = @parser.parse(scanner)
        parse_hsh[feat] = ast
      end
      parse_hsh
    end
  end
end