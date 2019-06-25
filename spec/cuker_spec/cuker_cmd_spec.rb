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

    def file_compare_test(res_file_name, stored_file_partial)
      res_data = File.read res_file_name
      # marshal = CukerSpecHelper.compare_binary res_data, marshal_file_name
      # expect(res_data).to eq marshal
      stored_file_name = CukerSpecHelper.compare_file res_data, stored_file_partial
      expect(FileUtils.compare_file(res_file_name,stored_file_name)).to eq true
    end

    def marshal_test(res_file_name, marshal_file_name)
      res_data = File.read res_file_name
      marshal = CukerSpecHelper.compare_marshal res_data, marshal_file_name
      expect(res_data).to be_similar_to marshal
    end

    context "ccmd preset usage" do
      let(:file_name) {"sample_report"}
      # let(:feat_path) {"spec/cuker_spec/testdata/sample/*"}
      let(:feat_path) {"spec/cuker_spec/testdata/good/*"}
      # let(:feat_path) {"spec/cuker_spec/testdata/good/data*"}
      it 'should jira package print stuff' do
        local_file_name = "jira_package"
        cc = CukerCmd.new
        res = cc.report :jira_package, feat_path, local_file_name
        exp_name = "^.*:.*reports.*#{LOG_TIME_TODAY}.*#{local_file_name}.*"
        expect(res.class).to eq(Array)
        expect(res.size).to eq(2)
        res.each {|f| expect(f).to match(exp_name)}
        res.each(&method(:demo_rename))
      end

      it 'should jira_text it' do
        local_file_name = "jira_text"
        cc = CukerCmd.new
        res = cc.report :jira_text, feat_path, local_file_name
        exp_name = "^.*:.*reports.*#{LOG_TIME_TODAY}.*#{local_file_name}.txt"
        expect(res.class).to eq(Array)
        expect(res.size).to eq(1)
        res.each {|f| expect(f).to match(exp_name)}

        # todo: enhance file production tests before ploughing on ahead
        marshal_test res.first, local_file_name
        res.each(&method(:demo_rename))
      end

      it 'should jira_excel it' do
        local_file_name = "jira_excel"
        cc = CukerCmd.new
        res = cc.report :jira_excel, feat_path, local_file_name
        exp_name = "^.*:.*reports.*#{LOG_TIME_TODAY}.*#{local_file_name}.xls"
        expect(res.class).to eq(Array)
        expect(res.size).to eq(1)
        res.each {|f| expect(f).to match(exp_name)}

        file_compare_test res.first, local_file_name
        res.each(&method(:demo_rename))
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