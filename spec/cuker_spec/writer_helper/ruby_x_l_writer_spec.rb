require_relative '../spec_helper'

module Cuker
  RSpec.describe RubyXLWriter do
    context 'init' do
      let(:w) {RubyXLWriter.new}

      it 'should start with a default sheet' do
        expect(w.sheets.size).to eq 0
      end

    end
  end
end