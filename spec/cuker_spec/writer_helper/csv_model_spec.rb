require_relative '../spec_helper'
require_relative '../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe CsvWriter do
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}

      it 'can recognize a feature asts, and parse out the data' do
        csvm = CsvModel.new [AST, AST], test_file
        title = csvm.title
        expect(title.count).to eq 7
        ap title
        rows = csvm.data
        expect(rows.size).to eq 4
        ap rows
      end

      it do
        csvm = CsvModel.new [AST], test_file
        # res = csvm.file
        # expect(res.empty?).to eq false
      end

    end
  end
end