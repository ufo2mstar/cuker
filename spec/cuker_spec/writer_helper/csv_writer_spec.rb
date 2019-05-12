require_relative '../spec_helper'

RSpec.describe CsvWriter do
  # context 'init' do
  #   let(:w) {CsvWriter.new OUTPUT_DIR}
  #
  #   it 'should start with a default sheet' do
  #     expect(w.sheets.size).to eq 1
  #   end
  #
  #   it 'should write a title increment counts' do
  #     expect(w.sheets.size).to eq 1
  #     expect(w.active_sheet.current_row).to eq 1
  #     w.write_title ['#','num','name']
  #     expect(w.active_sheet.rows.size).to eq 1
  #     expect(w.active_sheet.current_row).to eq 2
  #   end
  #
  #   it 'should write a title and a few rows' do
  #     w.write_title ['#','num','name']
  #     w.write_new_row %w[1 1 one]
  #     w.write_new_row %w[2 2 two]
  #     w.write_new_row %w[3 3 three]
  #     expect(w.active_sheet.rows.size).to eq 4
  #     expect(w.active_sheet.current_row).to eq 5
  #   end
  #
  #   it 'should add new named sheets' do
  #     expect(w.sheets.size).to eq 1
  #     w.make_new_sheet 'kod'
  #     expect(w.sheets.size).to eq 2
  #   end
  # end
end