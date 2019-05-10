# require 'rspec'
# require_relative '../gp'
require_relative 'spec_helper'

RSpec.describe "GherkinParserCmd" do
  context "object validation" do
    let(:gpc) {GherkinParserCmd.new}
    it 'should contain the following preset locations' do
      res = GherkinParserCmd::PRESET_LOCS
      exp = ['*', './*']
      expect(res).to eq exp
    end

    context "gp cmd usage" do
      it 'does simple gp' do
        # one arg
        res = gpc.gp 'loc'
        exp = nil
        expect(res).to eq exp

        # no arg default
        res = gpc.gp
        exp = nil
        expect(res).to eq exp
      end
      it 'does preset gp' do
        res = gpc.gpp
        exp = nil
        expect(res).to eq exp
      end
    end


    context "gp cmd to report usage" do
      it 'does simple gpr' do
        res = gpc.gpr 'loc', 'report'
        exp = nil
        expect(res).to eq exp
      end
    end
  end
end
