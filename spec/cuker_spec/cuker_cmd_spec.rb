require_relative 'spec_helper'

module Cuker
  RSpec.describe "CukerCmd" do
    let(:cc) {CukerCmd.new}

    context "Constants validation" do
      it 'should contain the following preset locations' do
        res = CukerCmd::PRESETS.keys
        exp = [:simple_csv, :simple_jira,:monospaced_jira]
        expect(res).to eq exp
      end
    end

    context "ccmd usage" do
      # skip "gp cmd usage" do
      let(:file_name) {"sample_report"}
      let(:feat_path) {"spec/cuker_spec/testdata/sample/05*"}
      it 'should read and write the good test data loc: simple_csv' do
        res = cc.report :simple_csv, feat_path
        exp_name = "^.*:.*reports.*#{file_name}.csv"
        expect(res).to match(exp_name)
      end

      it 'should read and write the good test data loc: jira' do
        local_file_name = 'simple_jira'
        res = cc.report :simple_jira, feat_path, local_file_name
        exp_name = "^.*:.*reports.*#{local_file_name }.txt"
        expect(res).to match(exp_name)
      end

      it 'should monospaced jira' do
        local_file_name = 'monospaced_jira'
        res = cc.report :monospaced_jira, feat_path, local_file_name
        exp_name = "^.*:.*reports.*#{local_file_name }.txt"
        expect(res).to match(exp_name)
      end
    end
  end
end