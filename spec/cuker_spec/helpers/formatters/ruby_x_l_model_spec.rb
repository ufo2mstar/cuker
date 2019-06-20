require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe RubyXLModel do
    let(:exp_title) {
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
    }
    # xcontext 'init' do
    #   let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}
    #
    #   it 'can recognize a feature asts, and parse out the data' do
    #     ast_map = {"blank.feature" => BLANK_AST,
    #                "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
    #                "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
    #     }
    #     rxlm = RubyXLModel.new ast_map
    #     title = rxlm.title
    #     expect(title.count).to eq 8
    #
    #     expect(title).to eq exp_title
    #
    #     rows = rxlm.data
    #     p rows
    #
    #     expect(rows.size).to eq 4
    #
    #     exp_rows =
    #         [["2.1", ["Feature:", "feat name", "feat desc"], [["Background:", "bg name", "bg desc"], " Given some setup"], [["Scenario:", "scen name", "scen desc line 1\n  scen desc line 2"], " Given this", "  When that:", "  Then kod", "   And kod", "   But kod", "     * kod"], nil, "Pending", "", ""], ["2.2", ["Feature:", "feat name", "feat desc"], [["Background:", "bg name", "bg desc"], " Given some setup"], [["ScenarioOutline:", "scen outline name <title>", "scen outline desc"], "  When this <thing>", "   And this <thing>", "  Then that <thang>"], nil, "Pending", "", ""], ["3.1", ["Feature:", "feature name", "feature description"], [["Background:", "background name", "background description"], "     * a step"], [["Scenario:", "scenario name", "scenario description"], "     * a step with a table"], nil, "Pending", "", ""], ["3.2", ["Feature:", "feature name", "feature description"], [["Background:", "background name", "background description"], "     * a step"], [["ScenarioOutline:", "outline name", "outline description"], "     * a step with a doc string"], nil, "Pending", "", ""]]
    #
    #     expect(rows).to eq exp_rows
    #   end
    # end

    context 'test extract methods' do
      it 'handles BG steps and Tables and Examples properly' do
        # feat_path = 'spec/cuker_spec/testdata/sample'
        feat_path = 'spec/cuker_spec/testdata/sample/05'
        gr = GherkinRipper.new feat_path
        ast_map = gr.ast_map
        # ap ast_map
        rxlm = RubyXLModel.new ast_map
        title = rxlm.title

        expect(title).to eq exp_title

        rows = rxlm.data
        snapshot_name = 'snap-sample05-RubyXLModel'
        CukerSpecHelper.snapshot_compare rows, snapshot_name
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