require_relative '../spec_helper'

describe StringHelper do
  context "usage test: should split string into n lines (with newlines)" do
    include StringHelper

    def check_limit str, n
      # str.split("\n").each {|s| expect(s.size).to be >= n} # rough guideline, not works kinda as expected
    end

    let(:str) {"What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset book containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."}
    it 'add_newlines_regex' do
      res = add_newlines_regex str, 20
      # puts res
      # p res
      exp = "What is Lorem Ipsum? \nLorem Ipsum is simply\n dummy text of the printing\n and typesetting industry\n. Lorem Ipsum has been\n the industry's standard\n dummy text ever since\n the 1500s, when an \nunknown printer took\n a galley of type and\n scrambled it to make\n a type specimen book\n. It has survived not\n only five centuries\n, but also the leap \ninto electronic typesetting\n, remaining essentially\n unchanged. It was popularised\n in the 1960s with the\n release of Letraset\n book containing Lorem\n Ipsum passages, and\n more recently with \ndesktop publishing software\n like Aldus PageMaker\n including versions \nof Lorem Ipsum."
      expect(res).to eq exp
      check_limit res, 20
    end
    it 'add_newlines' do
      res = add_newlines str, 20
      # puts res
      # p res
      exp = "What is Lorem Ipsum?\nLorem Ipsum is simply\ndummy text of the printing\nand typesetting industry.\nLorem Ipsum has been\nthe industry's standard\ndummy text ever since\nthe 1500s, when an unknown\nprinter took a galley\nof type and scrambled\nit to make a type specimen\nbook. It has survived\nnot only five centuries,\nbut also the leap into\nelectronic typesetting,\nremaining essentially\nunchanged. It was popularised\nin the 1960s with the\nrelease of Letraset\nbook containing Lorem\nIpsum passages, and\nmore recently with desktop\npublishing software\nlike Aldus PageMaker\nincluding versions of\nLorem Ipsum."
      expect(res).to eq exp
      check_limit res, 20
    end
    it 'add_newlines!' do
      res = add_newlines! str, 20
      # puts res
      # p res
      exp = "What is Lorem Ipsum?\nLorem Ipsum is simply\ndummy text of the printing\nand typesetting industry.\nLorem Ipsum has been\nthe industry's standard\ndummy text ever since\nthe 1500s, when an unknown\nprinter took a galley\nof type and scrambled\nit to make a type specimen\nbook. It has survived\nnot only five centuries,\nbut also the leap into\nelectronic typesetting,\nremaining essentially\nunchanged. It was popularised\nin the 1960s with the\nrelease of Letraset\nbook containing Lorem\nIpsum passages, and\nmore recently with desktop\npublishing software\nlike Aldus PageMaker\nincluding versions of\nLorem Ipsum."
      expect(res).to eq exp
      check_limit res, 20
    end
  end

end