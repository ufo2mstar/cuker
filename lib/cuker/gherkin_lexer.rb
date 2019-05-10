class GherkinLexer
  NonLexicalError = Class.new NotImplementedError

  attr_reader :lexed_ary

  def initialize raw_str_ary
    @raw_strs_ary = raw_str_ary
    @lexed_ary = []
  end

  def lex
    temp = nil
    @raw_strs_ary.each_with_index do |raw_str, line_num|
      res = case raw_str
            when /^\s*#/
              Comment.new raw_str
            else
              raise NonLexicalError.new "unable to lex line: '#{raw_str}'"
            end
      @lexed_ary << res
      temp = nil
    end
    @lexed_ary
  end
end