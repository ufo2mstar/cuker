module Cuker
  class GherkinLexer
    NonLexicalError = Class.new NotImplementedError

    attr_reader :lexed_ary
    attr :file_name

    def initialize raw_str_ary, file_name = nil
      @raw_strs_ary = raw_str_ary
      @file_name = file_name
      @lexed_ary = []
    end

    def lex
      # temp = nil
      @raw_strs_ary.each_with_index do |raw_str, line_num|
        res = case raw_str
              when /^\s*#/
                Comment.new raw_str
              else
                raise NonLexicalError.new "unable to lex line: #{line_num} :'#{raw_str}' #{"in file #{@file_name}" if @file_name}"
              end
        # if temp
        #   temp.items << Comment.new raw_str
        # else
        #   temp = nil
        # end
        @lexed_ary << res
      end
      @lexed_ary
    end
  end
end