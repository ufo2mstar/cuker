require_relative './helpers/gherkin_helper'

# == Gherkin Ripper
# does lexing and parsing (building a simple ParseTree for Cucumber Gherkins)
# adding a few support methods to ripping
#
module Cuker

  class GherkinRipper
    include GherkinHelper
    include LoggerSetup

    NoFilesFoundError = Class.new IOError

    attr_accessor :location
    attr_accessor :features
    # attr_reader :ast_map

    def initialize path = '*'
      init_logger

      @location = path.strip
      @location = '.' if @location.empty? # handle blank path searching all features

      ext = '.feature'
      @features = get_files @location, ext

      @log.trace "Gherkin ripper running at #{path}"
      @parser = Gherkin::Parser.new
      @ast_map = {}

      @log.trace "Parsed '.feature' files @ #{path} = #{@features.size} files"
    end

    def ast_map
      @ast_map = parse_all if @ast_map.empty?
      @ast_map
    end

    private

    # if you need to ignore any pattern of files, change this regex to match those patterns
    IGNORE_EXP = /^$/

    # dir glob for all files with extension = ext
    # @param location dir location of all the ext files
    def get_files(path_or_file, ext = '.feature')
      files = FileHelper.get_files(path_or_file, ext, IGNORE_EXP)
      files = FileHelper.get_file(path_or_file, ext, IGNORE_EXP) if files.empty?
      raise NoFilesFoundError.new "No '#{ext}' files found @ path '#{path_or_file}'... " if files.empty?
      @log.info "Number of '#{ext}' files to parse : @#{path_or_file} = #{files.size}"
      files
    end

    def parse_all
      parse_hsh = {}
      @features.each do |feat|
        @log.info "Parsing file: #{feat}"
        feature_text = File.read(feat)
        scanner = TokenScanner.new(feature_text)
        parse_handle(feat) {
          ast = @parser.parse(scanner)
          parse_hsh[feat] = ast
        }
      end
      parse_hsh
    end
  end
end