require_relative '../spec_helper'

RSpec.describe RubyXLWriter do
  context 'init' do
    let(:w) {RubyXLWriter.new}

    it 'should start with a default sheet' do
      expect(w.sheets.size).to eq 1
    end

    it 'should write a title increment counts' do
      expect(w.sheets.size).to eq 1
      expect(w.active_sheet.current_row).to eq 1
      w.write_title []
      expect(w.active_sheet.rows.size).to eq 1
      expect(w.active_sheet.current_row).to eq 2
    end

    it 'should write a title and a few rows' do
      w.write_title []
      w.write_new_row []
      w.write_new_row []
      w.write_new_row []
      expect(w.active_sheet.rows.size).to eq 4
      expect(w.active_sheet.current_row).to eq 5
    end

    it 'should add new named sheets' do
      expect(w.sheets.size).to eq 1
      w.make_new_sheet 'kod'
      expect(w.sheets.size).to eq 2
    end
  end
end