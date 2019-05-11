require_relative 'spec_helper'

module Cuker
  RSpec.describe GherkinRipper do
    describe "GherkinRipper init" do
      let(:test_loc) {'spec/cuker_spec/testdata'}

      context "plain id files" do
        let(:gr) {GherkinRipper.new(test_loc)}
        it 'should pick up all the features' do
          ans = gr.features.size
          expect(ans).to eq 45
        end
      end

    end
  end
end