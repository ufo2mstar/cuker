require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe JiraMonoModel do
    let(:exp_title) {"||Scen ID||Feature/Scenario||Steps||Result||"}
    # xcontext 'init' do
    #   let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}
    #   it 'can recognize a feature asts, and parse out the data' do
    #     ast_map = {"blank.feature" => BLANK_AST,
    #                "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
    #                "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
    #     }
    #
    #     csvm = JiraMonoModel.new ast_map
    #     title = csvm.title
    #
    #     expect(title).to eq exp_title
    #     rows = csvm.data
    #     snapshot_name = 'JiraMonoModel-snap-asttest'
    #     CukerSpecHelper.snapshot_compare rows, snapshot_name
    #   end
    # end

    context 'test extract methods' do
      it 'handles BG steps and Tables and Examples properly' do
        # feat_path = 'spec/cuker_spec/testdata/sample'
        feat_path = 'spec/cuker_spec/testdata/sample/05'
        gr = GherkinRipper.new feat_path
        ast_map = gr.ast_map
        # ap ast_map
        csvm = JiraMonoModel.new ast_map
        title = csvm.title

        expect(title).to eq exp_title

        rows = csvm.data
        snapshot_name = 'snap-sample05-JiraMonoModel'
        CukerSpecHelper.snapshot_compare rows, snapshot_name
      end

    end
  end
end