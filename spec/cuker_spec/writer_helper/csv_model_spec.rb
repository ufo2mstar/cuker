require_relative '../spec_helper'
require_relative '../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe CsvModel do
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}

      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
        }
        csvm = CsvModel.new ast_map
        title = csvm.title
        exp_title = ["Sl.No", "Type", "Title", "Feature", "S.no", "File", "Tags"]
        expect(title.count).to eq 7
        expect(title).to eq exp_title

        rows = csvm.data
        # p rows
        exp_rows = [[1, "S", "scen name - scen desc line 1\n  scen desc line 2", "feat name - feat desc", 1, "spec/cuker_spec/testdata/sample/sample_ast.rb", "@feat_tag1, @feat_tag2, @s_tag1, @s_tag2, @s_tag3"], [2, "SO", "scen outline name <title> - scen outline desc", "feat name - feat desc", 2, "spec/cuker_spec/testdata/sample/sample_ast.rb", "@feat_tag1, @feat_tag2, @s_tag1, @so_tag1"], [3, "S", "scenario name - scenario description", "feature name - feature description", 1, "spec/cuker_spec/testdata/sample/sample_ast_old.rb", "@feature_tag1, @feature_tag2, @feat_tag3, @scenario_tag"], [4, "SO", "outline name - outline description", "feature name - feature description", 2, "spec/cuker_spec/testdata/sample/sample_ast_old.rb", "@feature_tag1, @feature_tag2, @feat_tag3, @outline_tag"]]

        expect(rows.size).to eq 4
        expect(rows).to eq exp_rows
      end

    end

    context 'util methods' do
      it 'should filter special_tag_list ' do
        csvm = CsvModel.new({})
        csvm.special_tag_list = [
            {'spl' => "SecialTag"},
            {'spl_tag_2' => "Special Tag 2"},
        ]
        special_tag_id = ["spl", "spl_tag_2"]
        all_tags = ["tag_1", "tag2", "spl", "kod"]
        select_list, ignore_list = csvm.send(:filter_special_tags, all_tags)

        expect(select_list).to eq ["spl"]
        expect(ignore_list).to eq ["tag_1", "tag2", "kod"]
      end
    end
  end
end