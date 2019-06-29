require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe SummaryXLModel do
    let(:special_tags_hsh) {
      {
          "@s_tag1" => "Scen Tag 1",
          "@s_tag3" => "Tag 2",
          "@feat_tag2" => "Feat tag",
      }
    }


    def get_item_ary ary_of_hshs, item
      ary_of_hshs.map(&item).flatten
    end

    def get_values_ary ary_of_hshs
      get_item_ary ary_of_hshs, :values
    end

    def get_keys_ary ary_of_hshs
      get_item_ary ary_of_hshs, :keys
    end


    let(:special_tags) {
      # get_values_ary special_tags
      # get_keys_ary special_tags_hsh
      [
          "@s_tag1",
          "@s_tag3",
          "@s_tag4",
          "@feat_tag2",
      ]
    }
    let(:all_tags) {
      [
          "@feat_tag1",
          "@feat_tag2",
          "@s_tag1",
          "@s_tag2",
          "@s_tag3",
          "@so_tag1",
          "@so_tag2",
      ]
    }

    let(:exp_title) {
      exp_title = [
          "Sl.No",
          "Type",
          "Title",
          special_tags,
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
        rxlm = SummaryXLModel.new ast_map, special_tags
        # rxlm.special_tag_hsh = special_tag_titles

        title = rxlm.title

        expect(title).to eq exp_title

        rows = rxlm.data
        snapshot_name = 'snap-sample05-SummaryXLModel'
        res_rows, exp_rows = CukerSpecHelper.compare_snapshot rows, snapshot_name
        expect(res_rows.join "\n").to be_similar_to exp_rows.join "\n"
      end
    end

    context 'util methods' do
      it 'should filter special_tag_hsh ' do
        feat_path = 'spec/cuker_spec/testdata/sample/05'
        gr = GherkinRipper.new feat_path
        ast_map = gr.ast_map

        expect(all_tags).to eq ["@feat_tag1", "@feat_tag2", "@s_tag1", "@s_tag2", "@s_tag3", "@so_tag1", "@so_tag2"]

        expect(special_tags).to eq ["@s_tag1", "@s_tag3", "@s_tag4", "@feat_tag2"]

        rxlm = SummaryXLModel.new(ast_map, special_tags)
        # rxlm.special_tag_hsh = special_tags
        ordered_list, ignore_list, select_list = rxlm.send(:filter_special_tags, all_tags)

        expect(ordered_list).to eq ["@s_tag1", "@s_tag3", "", "@feat_tag2"]

        expect(ignore_list).to eq ["@feat_tag1", "@s_tag2", "@so_tag1", "@so_tag2"]

        expect(select_list).to eq ["@feat_tag2", "@s_tag1", "@s_tag3"]
      end
    end
  end

end