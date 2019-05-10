# require 'rspec'
require_relative '../spec_helper'

RSpec.describe FileHelper do
  context "usage test" do
    let(:path) {"."}
    let(:target_pattern) {"*.md"}
    it 'should get the dir glob on the given loc' do
      res = FileHelper.get_files path, target_pattern
      exp = ["./CHANGELOG.md", "./README.md"]
      expect(res).to eq exp
    end
    it 'should ignore files with target regex patterns' do
      ignore_pattern = /me/i
      res = FileHelper.get_files path, target_pattern, ignore_pattern
      exp = ["./CHANGELOG.md",]
      expect(res).to eq exp
    end
  end

end