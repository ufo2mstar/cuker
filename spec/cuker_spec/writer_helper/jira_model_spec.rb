require_relative '../spec_helper'
require_relative '../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe JiraModel do
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}

      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_dup.rb" => FULL_AST,
        }

        csvm = JiraModel.new ast_map
        title = csvm.title
        exp_title = ["||Scen ID||Scenario||Result||"]
        expect(title.count).to eq 1
        expect(title).to eq exp_title

        rows = csvm.data
        p rows
        puts rows.join "\n"
        exp_rows = [
            "|2.1|* a step with a table",
            "||a table|||(/)|",
            "|2.2|* a step with a doc string|(/)|",
            "|3.1|* a step with a table",
            "||a table|||(/)|",
            "|3.2|* a step with a doc string|(/)|"
        ]

        expect(rows.size).to eq 6
        expect(rows).to eq exp_rows
      end

    end
  end
end