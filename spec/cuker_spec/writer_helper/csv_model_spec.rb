require_relative '../spec_helper'
require_relative '../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe CsvModel do
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}

      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_dup.rb" => FULL_AST,
        }
        csvm = CsvModel.new ast_map
        title = csvm.title
        exp_title = ["Sl.No", "Type", "Title", "Feature", "S.no", "File", "Tags"]
        expect(title.count).to eq 7
        expect(title).to eq exp_title

        rows = csvm.data
        exp_rows = [
            [1, "S", "scenario name - scenario description", "feature name - feature description", 1, "spec/cuker_spec/testdata/sample/sample_ast.rb", ["@feature_tag1", "@feature_tag2", "@feat_tag3", "@scenario_tag"]],
            [2, "SO", "outline name - outline description", "feature name - feature description", 2, "spec/cuker_spec/testdata/sample/sample_ast.rb", ["@feature_tag1", "@feature_tag2", "@feat_tag3", "@outline_tag"]],
            [3, "S", "scenario name - scenario description", "feature name - feature description", 1, "spec/cuker_spec/testdata/sample/sample_ast_dup.rb", ["@feature_tag1", "@feature_tag2", "@feat_tag3", "@scenario_tag"]],
            [4, "SO", "outline name - outline description", "feature name - feature description", 2, "spec/cuker_spec/testdata/sample/sample_ast_dup.rb", ["@feature_tag1", "@feature_tag2", "@feat_tag3", "@outline_tag"]]
        ]

        expect(rows.size).to eq 4
        expect(rows).to eq exp_rows
      end

    end
  end
end