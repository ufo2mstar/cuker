require_relative 'log_utils'

# = Parse Gherkins into my mental models
#
# Init Parser and get to action on a given location
# @
module Cuker
  class GherkinParser
    include LoggerSetup

    attr_accessor :lex_ary

    def initialize lex = []
      init_logger
      @lex_ary = lex
      @log.trace "init parser for lexer with items: "
    end

    def parse

    end
  end
end
