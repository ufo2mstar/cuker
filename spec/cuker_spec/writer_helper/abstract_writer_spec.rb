require_relative '../spec_helper'

RSpec.describe AbstractWriter do
  context 'init' do
    it 'should follow this contract' do
      w = AbstractWriter.new
      # expect {w.write_new_row}.to raise_error(NotImplementedError, /implemented interface method: 'write_new_row'/)
      # expect {w.write_new_row}.to raise_error(NotImplementedError, "implemented interface method: 'write_new_row'")
      # puts w.methods
      expect(w.ext).to eq nil
    end

  end
end