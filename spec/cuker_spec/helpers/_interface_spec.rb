require_relative '../../spec_helper'

module Cuker
  RSpec.describe Interface do
    module TestModule
      extend Interface
      method :write_new_row
    end
    class InterfaceTest
      include TestModule
    end
    context 'init' do
      it 'should follow this contract' do
        w = InterfaceTest.new
        expect {w.write_new_row}.to raise_error(NotImplementedError, /please implement this interface method: 'write_new_row'/)
        expect {w.write_new_row}.to raise_error(NotImplementedError, "please implement this interface method: 'write_new_row'")
      end
      it 'should follow this contract' do
        w = InterfaceTest.new
        expect {w.undefined_method}.to raise_error(NoMethodError, /undefined method `undefined_method' for /)
      end
    end
  end
end