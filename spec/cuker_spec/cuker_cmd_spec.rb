require_relative 'spec_helper'

module Cuker

  RSpec.describe "CukerCmd" do
    let(:cc) {CukerCmd.new}

    context "Constants validation" do
      it 'should contain the following preset locations' do
        res = CukerCmd::PRODUCERS.keys
        # exp = [:simple_csv]
        # exp = [:simple_csv, :simple_jira]
        # exp = [:simple_csv, :simple_jira, :monospaced_jira]
        exp = [:simple_csv, :simple_jira, :monospaced_jira, :jira_excel]
        expect(res).to eq exp
      end

      it 'should contain the following preset locations' do
        res = CukerCmd::PRESETS.keys
        exp = [:jira_package, :jira_text, :jira_excel]
        expect(res).to eq exp
      end
    end

    def demo_rename(res)
      File.rename res, "#{res}#{REPORT_FILE_NAME}"
    end

    context "ccmd preset usage" do
      let(:file_name) {"sample_report"}
      # let(:feat_path) {"spec/cuker_spec/testdata/sample/05*"}
      let(:feat_path) {"spec/cuker_spec/testdata/good/*"}
      it 'should excel' do
        local_file_name = "cmd test"
        cc = CukerCmd.new
        res = cc.report :jira_package, feat_path, local_file_name
        exp_name = "^.*:.*reports.*#{LOG_TIME_TODAY}.*#{local_file_name}.*"
        expect(res.class).to eq(Array)
        expect(res.size).to eq(2)
        res.each {|f| expect(f).to match(exp_name)}
        # demo_rename res
      end
    end

      # xcontext "ccmd preset usage" do
      #   # skip "gp cmd usage" do
      #   let(:file_name) {"sample_report"}
      #   let(:feat_path) {"spec/cuker_spec/testdata/sample/05*"}
      #   it 'should read and write the good test data loc: simple_csv' do
      #     res = cc.report :simple_csv, feat_path
      #     exp_name = "^.*:.*reports.*#{file_name}.csv"
      #     expect(res).to match(exp_name)
      #     demo_rename res
      #   end
      #
      #   it 'should read and write the good test data loc: jira' do
      #     local_file_name = 'simple_jira'
      #     res = cc.report :simple_jira, feat_path, local_file_name
      #     exp_name = "^.*:.*reports.*#{local_file_name }.txt"
      #     expect(res).to match(exp_name)
      #     demo_rename res
      #   end
      #
      #   it 'should monospaced jira' do
      #     local_file_name = 'monospaced_jira'
      #     res = cc.report :monospaced_jira, feat_path, local_file_name
      #     exp_name = "^.*:.*reports.*#{local_file_name }.txt"
      #     expect(res).to match(exp_name)
      #     demo_rename res
      #   end
      # end
  end
end