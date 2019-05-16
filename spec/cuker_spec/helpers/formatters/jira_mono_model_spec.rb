require_relative '../../spec_helper'
require_relative '../../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe JiraMonoModel do
    let(:exp_title) {"||Scen ID||Feature/Scenario||Steps||Result||"}
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}
      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
        }

        csvm = JiraMonoModel.new ast_map
        title = csvm.title

        expect(title).to eq exp_title
        rows = csvm.data
        CukerSpecHelper.debug_show(rows)
        exp_rows = ["|2|{panel} *Feature:* feat name", "feat desc", " *Background:* bg name", "bg desc", "  {panel}|{panel} {{*Given*}} {{some setup}} {panel}|| ||", "|2.1|{panel} *Scenario:* scen name", "scen desc line 1", "  scen desc line 2", "  {panel}|{panel} {{*Given*}} {{this}}", " {{*When*}} {{that:}}", "||{{tab}}||", "|{{1}}|", "|{{two}}|", " {{*Then*}} {{kod}}", "  {{*And*}} {{kod}}", "  {{*But*}} {{kod}}", "    {{***}} {{kod}} {panel}||(i)||", "|2.2|{panel} *ScenarioOutline:* scen outline name *_<title>_*", "scen outline desc", "  {panel}|{panel}  {{*When*}} {{this *_<thing>_*}}", "  {{*And*}} {{this *_<thing>_*}}", "||{{tab}}||", "|{{1}}|", "|{{two}}|", " {{*Then*}} {{that *_<thang>_*}}", "----", "*Examples:* example name", "example desc", " ", "||{{title}}||{{thing}}||{{thang}}||", "|{{case 1}}|{{1}}|{{one}}|", "|{{case 2}}|{{2}}|{{two}}| {panel}||(i)||", "|3|{panel} *Feature:* feature name", "feature description", " *Background:* background name", "background description", "  {panel}|{panel}     {{***}} {{a step}} {panel}|| ||", "|3.1|{panel} *Scenario:* scenario name", "scenario description", "  {panel}|{panel}     {{***}} {{a step with a table}}", "||{{a table}}|| {panel}||(i)||", "|3.2|{panel} *ScenarioOutline:* outline name", "outline description", "  {panel}|{panel}     {{***}} {{a step with a doc string}}", "----", "*Examples:* examples name", "examples description", " ", "||{{param}}||", "|{{value}}| {panel}||(i)||"]

        # expect(rows.size).to eq 50
        expect(rows).to eq exp_rows
      end
    end

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
        CukerSpecHelper.debug_show(rows)
        snapshot_name = 'sample-05-JiraMonoModel'
        # CukerSpecHelper.snapshot_store(rows, snapshot_name)

        exp_rows = CukerSpecHelper.snapshot_compare snapshot_name
        expect(rows).to eq exp_rows
      end

    end
  end
end