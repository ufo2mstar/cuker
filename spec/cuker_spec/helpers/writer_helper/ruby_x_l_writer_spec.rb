require_relative '../../spec_helper'

module Cuker
  RSpec.describe RubyXLWriter do
    subject(:w) {RubyXLWriter.new}
    context 'init' do

      it 'should have an xlsx extension' do
        expect(w.ext).to eq '.xlsm'
      end

      it 'should start with no default book' do
        expect(w.book.size).to eq 0
      end

      it 'should make a new sheet from path and filename given and return the name' do
        file_path = w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_file0"
        expect(w.book.size).to eq 1
        w.finishup
        expect(file_path).to eq "reports/#{LOG_TIME_TODAY}/demo_file0#{w.ext}"
        #   todo: unknown path test, etc
      end
      it 'should throw errors if writes are invoked before making new sheet first' do
        # todo: raise better errors, than nil errors
        expect {w.write_title ['kod']}.to raise_error AbstractWriter::NoNewFileMadeError
        expect {w.write_new_row ['kod']}.to raise_error AbstractWriter::NoNewFileMadeError
      end

      it 'should write a title increment counts' do
        w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_file1"
        expect(w.book.size).to eq 1
        expect(w.active_file.current_row).to eq 4
        w.write_title ['#', 'num', 'name']
        expect(w.active_file.rows.size).to eq 6
        # expect(w.active_file.current_row).to eq 2
        w.finishup
      end

      it 'should write a title and a few rows' do
        w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_file2"
        w.write_title ['#', 'num', 'name']
        w.write_new_row %w[1 1 one]
        w.write_new_row %w[2 2 two]
        w.write_new_row %w[3 3 three]
        # expect(w.active_file.rows.size).to eq 4
        # expect(w.active_file.current_row).to eq 5
        w.finishup
      end

      it 'should add new named book' do
        w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_file"
        expect(w.book.size).to eq 1
        # overwrite test
        w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_file"
        expect(w.book.size).to eq 1
        # new file
        w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_file_2"
        expect(w.book.size).to eq 2
        w.finishup
      end
    end

    context "Writer combo test" do

      context 'test extract methods' do
        it 'handles BG steps and Tables and Examples properly' do
          # feat_path = 'spec/cuker_spec/testdata/sample'
          feat_path = 'spec/cuker_spec/testdata/sample/05'
          gr = GherkinRipper.new feat_path
          ast_map = gr.ast_map
          # ap ast_map
          rxlm = RubyXLModel.new ast_map
          title = rxlm.title

          exp_title = [
              "Sl.No",
              "Feature",
              "Background",
              "Scenario",
              "Examples",
              "Result",
              "Tested By",
              "Test Designer",
              "Comments",
          ]

          expect(title).to eq exp_title

          rows = rxlm.data
          snapshot_name = 'snap-sample05-RubyXLModel'
          res_rows, exp_rows = CukerSpecHelper.snapshot_compare rows, snapshot_name
          expect(res_rows.join "\n").to be_similar_to exp_rows.join "\n"
        end
      end

      context 'actually writing the result' do
        it 'should generate the expected output' do
          snapshot_name = 'snap-sample05-RubyXLModel'
          data = CukerSpecHelper.snapshot_retrieve snapshot_name
          # p data
          w.make_new_file "reports/#{LOG_TIME_TODAY}/demo_sample_05"
          data.each {|row| w.write_new_row row}
          w.finishup
        end
      end
    end

  end
end