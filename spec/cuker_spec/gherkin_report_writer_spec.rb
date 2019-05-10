require_relative 'spec_helper'


FileNotRemoved = Class.new StandardError

RSpec.describe GherkinReportWriter do
  include LoggerSetup

  describe "GRW init" do
    REPORT_FILE_LOC = 'reports'
    REPORT_FILE_NAME = 'demo_file'

    let(:glob_str) {File.join(REPORT_FILE_LOC, '**', REPORT_FILE_NAME + '*')}
    let(:grw) {GherkinReportWriter.new(REPORT_FILE_LOC, REPORT_FILE_NAME)}

    # before(:all) do
    #   init_logger
    #   @log.debug "before all block"
    # end
    #
    # before(:each) do
    #   @log.debug "before all block"
    # end
    #
    # after(:all) do
    #   @log.debug "before all block"
    # end

    after(:each) do
      glob_str = File.join(REPORT_FILE_LOC, '**', REPORT_FILE_NAME + '*')
      ans = Dir.glob(glob_str)
      FileUtils.rm ans
      ans = Dir.glob(glob_str)
      raise FileNotRemoved.new("please see why the file #{ans} is not removed yet") if ans.any?
    end

    context "file create check" do
      it 'should output a demo_report file' do
        grw
        ans = Dir.glob(glob_str)
        expect(ans.size).to eq 1
      end
    end

    context "file populate check" do
      let(:gpo) {
        # gherkin parsed objs
        gpo = GherkinParser.new
        gpo.features = [Feature.new("Feature: kod")]
        gpo
      }

      it 'should output a demo_report file' do
        grw
        ans = Dir.glob(glob_str)
        grw.add_feature_row gpo.features[0]
        expect(ans.size).to eq 1
      end
    end
  end

  describe "write out" do
    context "with a sample feature model" do

    end
  end

end
