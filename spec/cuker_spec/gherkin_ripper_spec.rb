require_relative 'spec_helper'

module Cuker
  RSpec.describe GherkinRipper do
    describe "GherkinRipper init" do

      context "plain id files" do
        let(:test_loc) {'spec/cuker_spec/testdata'}
        let(:gr) {GherkinRipper.new(test_loc)}
        it 'should pick up all the features' do
          ans = gr.features.size
          expect(ans).to eq 45
        end
      end

      context "ripping for gherk ast" do
        let(:test_loc) {'spec/cuker_spec/testdata/sample'}
        it 'should pick up all the features' do
          gr = GherkinRipper.new(test_loc)
          ans = gr.features.size
          expect(ans).to eq 6
          asts = gr.ast_map
          asts.each { |ast| puts ast.ai(plain: true, raw: true) }
          expect(asts.size).to eq 6
        end
      end

    end
  end
end