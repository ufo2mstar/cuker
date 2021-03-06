require_relative 'spec_helper'

module Cuker

  RSpec.describe GherkinReporter do
    # FileNotRemoved = Class.new StandardError
    # include LoggerSetup
    #
    # describe "GRW init" do
    #   REPORT_FILE_LOC = 'reports'
    #   REPORT_FILE_NAME = 'demo_file'
    #
    #   let(:glob_str) {File.join(REPORT_FILE_LOC, '**', REPORT_FILE_NAME + '*')}
    #   let(:grw) {GherkinReporter.new(REPORT_FILE_LOC, REPORT_FILE_NAME)}
    #
    #   # before(:all) do
    #   #   init_logger
    #   #   @log.debug "before all block"
    #   # end
    #   #
    #   # before(:each) do
    #   #   @log.debug "before all block"
    #   # end
    #   #
    #   # after(:all) do
    #   #   @log.debug "before all block"
    #   # end
    #
    #   after(:each) do
    #     glob_str = File.join(REPORT_FILE_LOC, '**', REPORT_FILE_NAME + '*')
    #     ans = Dir.glob(glob_str)
    #     FileUtils.rm ans
    #     ans = Dir.glob(glob_str)
    #     raise FileNotRemoved.new("please see why the file #{ans} is not removed yet") if ans.any?
    #   end
    #
    #   context "file create check" do
    #     it 'should output a demo_report file' do
    #       grw
    #       ans = Dir.glob(glob_str)
    #       expect(ans.size).to eq 1
    #     end
    #   end
    #
    #   context "file populate check" do
    #     let(:gpo) {
    #       # gherkin parsed objs
    #       gpo = GherkinRipper.new
    #       gpo.features = [Feature.new("Feature: kod")]
    #       gpo
    #     }
    #
    #     it 'should output a demo_report file' do
    #       grw
    #       ans = Dir.glob(glob_str)
    #       grw.add_feature_row gpo.features[0]
    #       expect(ans.size).to eq 1
    #     end
    #   end
    # end

    describe "write out" do

      it "with a sample feature model" do
        title = [
            {kod: "num"},
            {sar: "text"},
        ]
        data = [
            ["1", "one"],
            ["2", "two"],
        ]
        am = AbstractModel.new

        model = double("model double", :title => am.get_values_ary(title), :data => data)
        csv_model = model

        path = "reports/#{LOG_TIME_TODAY}"
        csv_writer = CsvWriter.new
        file_name = "demo"

        gr = GherkinReporter.new csv_writer, csv_model, path, file_name
        out_file_name = gr.write
        exp_name = "reports.*#{file_name}.csv"
        expect(out_file_name).to match(exp_name)

      end

      it "with all test feature models" do
        feat_path = "spec/cuker_spec/testdata/sample"
        gr = GherkinRipper.new feat_path
        ast_map = gr.ast_map

        csv_model = JiraModel.new ast_map
        csv_writer = JiraWriter.new

        path = "reports/#{LOG_TIME_TODAY}"
        file_name = "demo"

        gr = GherkinReporter.new csv_writer, csv_model, path, file_name
        out_file_name = gr.write
        exp_name = "reports.*#{file_name}.txt"
        expect(out_file_name).to match(exp_name)
      end
    end

  end
end