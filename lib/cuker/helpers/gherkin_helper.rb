require 'gherkin/parser'
require 'gherkin/token_scanner'
require 'gherkin/token_matcher'
require 'gherkin/ast_builder'
require 'gherkin/errors'

module GherkinHelper
  include Gherkin

  def parse_handle(file_name)
    begin
      yield
    rescue Gherkin::ParserError => e
      msg = "unable to read #{file_name}..\n  Issues:\n#{error_digest e}"
      @log.error msg
      #todo: handle issues promot to user on cli
    end
  end

  def error_digest(e)
    # todo: maybe give friendly error promots?
    e.errors.map do |err|
      err.message
          .gsub(/^\((\d+):(\d+)\):/, '    ( line \1 : char \2 ) :')
          # .gsub(' : ', "\t:\t") # not so pretty, but if needed
    end.join "\n"
  end
end