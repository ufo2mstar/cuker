# require 'rspec'
# require_relative '../gp'
require_relative 'spec_helper'

module Cuker
  RSpec.describe "GherkinParserCmd" do
    context "object validation" do
      let(:gpc) {GherkinParserCmd.new}
      it 'should contain the following preset locations' do
        res = GherkinParserCmd::PRESET_LOCS
        exp = ['*', './*']
        expect(res).to eq exp
      end

      context "gp cmd usage" do
        # it 'does simple gp' do
        #   # one arg
        #   res = gpc.gp 'loc'
        #   exp = true
        #   expect(res).to eq exp
        # 
        #   # no arg default
        #   res = gpc.gp
        #   exp = true
        #   expect(res).to eq exp
        # end
        # 
        # it 'does preset gp' do
        #   res = gpc.gpp
        #   exp = true
        #   expect(res).to eq exp
        # end
        # 
        it 'should read and write the good test data loc: csv' do
          # res = gpc.gpr
        end

        it 'should read and write the good test data loc: jira' do
          res = gpc.gpj
        end
      end


      context "gp cmd to report usage" do
        # it 'does simple gpr' do
        #   res = gpc.gpr 'loc', 'reports'
        #   exp = true
        #   expect(res).to eq exp
        # end
      end
    end
  end
end