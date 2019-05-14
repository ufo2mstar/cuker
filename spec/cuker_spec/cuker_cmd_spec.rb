require_relative 'spec_helper'

module Cuker
  RSpec.describe "CukerCmd" do
    let(:cc) {CukerCmd.new}

    context "Constants validation" do
      it 'should contain the following preset locations' do
        res = CukerCmd::PRESETS.keys
        exp = [:simple_csv, :simple_jira]
        expect(res).to eq exp
      end
    end

    xcontext "ccmd usage" do
      # skip "gp cmd usage" do
      it 'should read and write the good test data loc: simple_csv' do
        res = cc.report :simple_csv
      end

      it 'should read and write the good test data loc: jira' do
        res = cc.report :simple_jira
      end
    end
  end
end