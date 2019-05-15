require_relative '../spec_helper'
require_relative '../../../spec/cuker_spec/testdata/sample/sample_ast'

module Cuker
  RSpec.describe JiraModel do
    let(:exp_title) {"||Scen ID||Feature/Scenario||Steps||Result||"}
    context 'init' do
      let(:test_file) {'spec/cuker_spec/testdata/sample/sample_ast.rb'}
      it 'can recognize a feature asts, and parse out the data' do
        ast_map = {"blank.feature" => BLANK_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast.rb" => FULL_AST,
                   "spec/cuker_spec/testdata/sample/sample_ast_old.rb" => OLD_AST,
        }

        csvm = JiraModel.new ast_map
        title = csvm.title

        expect(title).to eq exp_title
        rows = csvm.data
        # p
        # p rows
        # puts rows.join "\n"
        exp_rows = ["|2|*Feature:* feat name", "feat desc", "*Background:* bg name", "bg desc", "|{panel} *Given* some setup {panel}|| ||", "|2.1|*Scenario:* scen name", "scen desc line 1", "  scen desc line 2", "|{panel} *Given* this", "*When* that:", "||tab||", "|1|", "|two|", "*Then* kod", "*And* kod", "*But* kod", "*** kod {panel}||(!)||", "|2.2|*ScenarioOutline:* scen outline name <title>", "scen outline desc", "|{panel} *When* this <thing>", "*And* this <thing>", "||tab||", "|1|", "|two|", "*Then* that <thang>", " ", "*Examples:* example name", "example desc", "", "||title||thing||thang||", "|case 1|1|one|", "|case 2|2|two| {panel}||(i)||", "|3|*Feature:* feature name", "feature description", "*Background:* background name", "background description", "|{panel} *** a step {panel}|| ||", "|3.1|*Scenario:* scenario name", "scenario description", "|{panel} *** a step with a table", "||a table|| {panel}||(!)||", "|3.2|*ScenarioOutline:* outline name", "outline description", "|{panel} *** a step with a doc string", " ", "*Examples:* examples name", "examples description", "", "||param||", "|value| {panel}||(i)||"]


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
        csvm = JiraModel.new ast_map
        title = csvm.title

        expect(title).to eq exp_title

        rows = csvm.data
        # p
        # p rows
        # puts rows.join "\n"
        exp_rows = ["|1|*Feature:* feat name", "feat desc", "*Background:* bg name", "bg desc", "|{panel} *Given* bg step 1", "*When* bg step 2", "*Then* bg step 3", "*And* bg step 4", "*But* bg step 5 {panel}|| ||", "|1.1|*Scenario:* scen name", "scen desc line 1", "  scen desc line 2", "|{panel} *Given* bg step 1", "*When* bg step 2", "*Then* bg step 3", "*And* bg step 4", "*But* bg step 5", "*When* table", "||tab||", "|1|", "|two|", "*Then* kod 1", "*And* kod2", "*But* kod3", "*** kod4 {panel}||(!)||", "|1.2|*ScenarioOutline:* scen outline name <title>", "scen outline desc", "|{panel} *Given* bg step 1", "*When* bg step 2", "*Then* bg step 3", "*And* bg step 4", "*But* bg step 5", "*When* this <thing>", "*And* this <thing>", "||tab||", "|1|", "|two|", "*Then* that <thang>", " ", "*Examples:* example name", "example desc", "", "||title||thing||thang||", "|case 1|1|one|", "|case 2|1|one|", "| | | |", "|blank case 3| | |", "| | | | {panel}||(i)||"]

        # expect(rows.size).to eq 48
        expect(rows).to eq exp_rows
      end

    end
  end
end