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
        # p rows
        # puts rows.join "\n"
        exp_rows = ["|2|Feature: feat name - feat desc", "Background: bg name - bg desc|{panel} *Given* some setup {panel}||||", "|2.1|scen name - scen desc line 1", "  scen desc line 2|{panel} *Given* this", "*When* that:", "||tab||", "|1|", "|two|", "*Then* kod", "*And* kod", "*But* kod", "*** kod {panel}||(!)||", "|2.2|scen outline name <title> - scen outline desc|{panel} *When* this <thing>", "*And* this <thing>", "||tab||", "|1|", "|two|", "*Then* that <thang>", " ", "Examples: example name - example desc", "||title||thing||thang||", "|case 1|1|one|", "|case 2|2|two| {panel}||(i)||", "|3|Feature: feature name - feature description", "Background: background name - background description|{panel} *** a step {panel}||||", "|3.1|scenario name - scenario description|{panel} *** a step with a table", "||a table|| {panel}||(!)||", "|3.2|outline name - outline description|{panel} *** a step with a doc string", " ", "Examples: examples name - examples description", "||param||", "|value| {panel}||(i)||"]

        expect(rows.size).to eq 32
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
        exp_rows = ["|1|Feature: feat name - feat desc", "Background: bg name - bg desc|{panel} *Given* some setup {panel}||||", "|1.1|scen name - scen desc line 1", "  scen desc line 2|{panel} *Given* this", "*When* that:", "||tab||", "|1|", "|two|", "*Then* kod", "*And* kod", "*But* kod", "*** kod {panel}||(!)||", "|1.2|scen outline name <title> - scen outline desc|{panel} *When* this <thing>", "*And* this <thing>", "||tab||", "|1|", "|two|", "*Then* that <thang>", " ", "Examples: example name - example desc", "||title||thing||thang||", "|case 1|1|one|", "|case 2|2|two| {panel}||(i)||"]

        expect(rows.size).to eq 23
        expect(rows).to eq exp_rows
      end

    end
  end
end