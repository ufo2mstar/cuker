require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe SummaryXLModel do
    let(:special_tag_titles) {
      [
          "@s_tag1",
          "@s_tag3",
      ]
    }

    let(:exp_title) {
      exp_title = [
          "Sl.No",
          "Type",
          "Title",
          special_tag_titles,
          "Other Tags",
          "Feature",
          "Background",
          "Scen.no",
          "File",
      ].flatten
    }


    context 'test extract methods' do
      it 'handles BG steps and Tables and Examples properly' do
        # feat_path = 'spec/cuker_spec/testdata/sample'
        feat_path = 'spec/cuker_spec/testdata/sample/05'
        gr = GherkinRipper.new feat_path
        ast_map = gr.ast_map
        # ap ast_map
        rxlm = SummaryXLModel.new ast_map,special_tag_titles
        # rxlm.special_tag_list = special_tag_titles

        title = rxlm.title

        expect(title).to eq exp_title

        rows = rxlm.data
        snapshot_name = 'snap-sample05-SummaryXLModel'
        res_rows, exp_rows = CukerSpecHelper.compare_snapshot rows, snapshot_name
        expect(res_rows.join "\n").to be_similar_to exp_rows.join "\n"
      end
    end

    context 'util methods' do
      it 'should filter special_tag_list ' do
        rxlm = SummaryXLModel.new({})
        rxlm.special_tag_list = [
            {'spl' => "SecialTag"},
            {'spl_tag_2' => "Special Tag 2"},
        ]
        special_tag_id = ["spl", "spl_tag_2"]
        all_tags = ["tag_1", "tag2", "spl", "kod"]
        select_list, ignore_list = rxlm.send(:filter_special_tags, all_tags)

        expect(select_list).to eq ["spl"]
        expect(ignore_list).to eq ["tag_1", "tag2", "kod"]
      end
    end
  end

end