require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe RubyXLModel do
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}

      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
        }
        rxlm = RubyXLModel.new ast_map
        title = rxlm.title
        expect(title.count).to eq 8
        exp_title = [
            "Sl.No",
            "Feature",
            "Background",
            "Scenario",
            "Examples",
            "Result",
            "Tested By",
            "Test Designer",
        ]
        expect(title).to eq exp_title

        rows = rxlm.data

        # p rows
        expect(rows.size).to eq 6

        exp_rows = [[], [], [], [], [], []]
        expect(rows).to eq exp_rows
      end

    end

    context 'util methods' do
      it 'should filter special_tag_list ' do
        rxlm = RubyXLModel.new({})
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