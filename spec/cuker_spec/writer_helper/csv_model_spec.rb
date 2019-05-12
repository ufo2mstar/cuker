require_relative '../spec_helper'
require_relative '../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe CsvWriter do
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}

      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_dup.rb" => FULL_AST,
        }
        csvm = CsvModel.new ast_map
        title = csvm.title
        expect(title.count).to eq 7
        # ap title
        rows = csvm.data
        expect(rows.size).to eq 4
        # ap rows
      end

    end
  end
end