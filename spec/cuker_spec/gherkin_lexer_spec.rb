# require 'rspec'
require_relative 'spec_helper'

# RAW_STR = <<-EOS
#
# EOS

RSpec.describe "GherkinLexer" do
  context "basic interface check" do
    # let(:raw_str) {RAW_STR}
    # let(:gl) {GherkinLexer.new}
    it 'should lex a str' do
      line_str = "# sample comment"
      gl = GherkinLexer.new [line_str]
      res = gl.lex
      # exp = [Comment.new(line_str)]
      # expect(res).to eq exp
      expect(res.size).to eq 1
      expect(res[0].class).to eq Comment
    end
    it 'should raise unable to lex error if unable' do
      line_str = "sample simple line"
      gl = GherkinLexer.new [line_str]
      expect {gl.lex}.to raise_error GherkinLexer::NonLexicalError
    end
  end

end