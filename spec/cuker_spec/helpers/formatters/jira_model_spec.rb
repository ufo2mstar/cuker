require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe JiraModel do
    let(:exp_title) {"||Scen ID||Feature/Scenario||Steps||Result||"}
    # xcontext 'init' do
    #   let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}
    #   it 'can recognize a feature asts, and parse out the data' do
    #     ast_map = {"blank.feature" => BLANK_AST,
    #                "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
    #                "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
    #     }
    #
    #     jm = JiraModel.new ast_map
    #     title = jm.title
    #
    #     expect(title).to eq exp_title
    #     rows = jm.data
    #     snapshot_name = 'JiraModel-snap-asttest'
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
        jm = JiraModel.new ast_map
        title = jm.title

        expect(title).to eq exp_title

        rows = jm.data
        snapshot_name = 'snap-sample05-JiraModel'
        CukerSpecHelper.snapshot_compare rows, snapshot_name
      end
    end

    context 'test util methods' do
      let(:jm) {JiraModel.new({})}

      def check method_name_sym, inp, exp
        expect(jm.send(method_name_sym, inp)).to eq exp
      end

      context 'jira_arg_hilight' do
        it 'should do simple strs' do
          inp = "a <fast> fox"
          exp = "a *_<fast>_* fox"
          check :jira_arg_hilight, inp, exp
        end
        it 'should do simple strs' do
          inp = "a <fast> <brown> fox is <lazy>"
          exp = "a *_<fast>_* *_<brown>_* fox is *_<lazy>_*"
          check :jira_arg_hilight, inp, exp
        end
        it 'should do simple strs' do
          inp = "a <fast and furious><brown> fox is> <lazy"
          exp = "a *_<fast and furious>_**_<brown>_* fox is> <lazy"
          check :jira_arg_hilight, inp, exp
        end
      end
    end
  end
end
