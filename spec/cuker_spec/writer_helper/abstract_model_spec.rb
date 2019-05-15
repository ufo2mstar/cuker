require_relative '../spec_helper'

module Cuker
  RSpec.describe AbstractModel do
    context 'model util methods' do
      it 'should parse out keys and values into an ary' do
        am = AbstractModel.new
        ary_of_hsh = [
            {one: 1},
            {two: "2"},
        ]

        keys = am.get_keys_ary ary_of_hsh
        exp_keys = [:one, :two]
        expect(keys).to eq exp_keys

        vals = am.get_values_ary ary_of_hsh
        exp_vals = [1, "2"]
        expect(vals).to eq exp_vals
      end

    end
  end
end