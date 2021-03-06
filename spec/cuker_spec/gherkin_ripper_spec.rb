require_relative 'spec_helper'

module Cuker
  RSpec.describe GherkinRipper do
    describe "GherkinRipper init" do
      # before(:all) do
      #   LoggerSetup.reset_appender_log_levels :trace
      # end
      # after(:all) do
      #   LoggerSetup.reset_appender_log_levels
      # end
      context "plain id files" do
        # let(:test_loc) {'spec/cuker_spec/testdata'}
        # let(:gr) {GherkinRipper.new(test_loc)}
        it 'should pick up all the features' do
          path = 'spec/cuker_spec/testdata'
          gr = GherkinRipper.new(path)
          ans = gr.features.size
          expect(ans).to eq 45
        end
        it 'should pick up a specific feature' do
          path = 'spec/cuker_spec/testdata/sample/05_with_all'
          gr = GherkinRipper.new(path)
          ans = gr.features.size
          expect(ans).to eq 1
        end
        it 'should not pick up any features' do
          path = 'lib'
          expect {gr = GherkinRipper.new(path)}.to raise_error GherkinRipper::NoFilesFoundError
          # ans = gr.features.size
          # expect(ans).to eq 0
        end
        it 'should default to searching from curr dir if not path is provided' do
          path = '  '
          gr = GherkinRipper.new(path)
          ans = gr.features.size
          expect(ans).to eq 46
        end
      end

      context "ripping for gherk ast" do
        it 'should pick up all the features' do
          test_loc = 'spec/cuker_spec/testdata/sample'
          gr = GherkinRipper.new(test_loc)
          ans = gr.features.size
          expect(ans).to eq 6
          asts = gr.ast_map
          # asts.each {|ast| puts ast.ai(plain: true, raw: true)}
          expect(asts.size).to eq 6
        end
        it 'should pick up all bad features' do
          test_loc = 'spec/cuker_spec/testdata/bad'
          gr = GherkinRipper.new(test_loc)
          ans = gr.features.size
          expect(ans).to eq 8
          asts = gr.ast_map
          # expect {asts = gr.ast_map}.to raise_error(Gherkin::ParserError)
          # asts.each {|ast| puts ast.ai(plain: true, raw: true)}
          expect(asts.size).to eq 0
        end
        it 'should pick up all good features and ignore all bad features' do
          test_loc = 'spec/cuker_spec/testdata'
          gr = GherkinRipper.new(test_loc)
          ans = gr.features.size
          expect(ans).to eq 45
          asts = gr.ast_map
          # expect {asts = gr.ast_map}.to raise_error(Gherkin::ParserError)
          # asts.each {|ast| puts ast.ai(plain: true, raw: true)}
          expect(asts.size).to eq 37
        end
      end

    end
  end
end