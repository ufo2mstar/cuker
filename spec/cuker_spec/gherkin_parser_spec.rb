require_relative 'spec_helper'
# require 'awesome_print'

module Cuker


  RSpec.describe GherkinParser do
    describe "GP init" do
      
      SIMPLE_FEATURE = <<-EOF
# comment above feat
@feat_tag
Feature: feat desc

  Background: bg desc
      Given some setup

  @scen_tag1 @scen_tag2
  Scenario: scen desc
    Given this
    When that
    Then kod

  @scen_out_tag
  Scenario Outline: scen outline desc <title>
    When this <thing>
    Then that <thang>
    Examples:
      | title  | thing | thang |
      | case 1 | 1     | one   |
      | case 2 | 2     | two   |

      EOF

      def simple_sample_feature_obj scen_str
        file_lines = scen_str.split "\n"
        feat_comment = Comment.new file_lines.shift
        feat_tags = Tags.new file_lines.shift
        feat = Feature.new file_lines.shift
        feat.comments = feat_comment
        feat.tags = feat_tags
        skip = file_lines.shift
        back = Background.new file_lines.shift
        bg_step = Step.new file_lines.shift
        back.items << bg_step
        skip = file_lines.shift
        scen_tags = Tags.new file_lines.shift
        scen = Scenario.new file_lines.shift
        scen.tags = scen_tags
        scen_step_1 = Step.new file_lines.shift
        scen_step_2 = Step.new file_lines.shift
        scen_step_3 = Step.new file_lines.shift
        scen.steps << [scen_step_1, scen_step_2, scen_step_3]
        feat.items << scen
        skip = file_lines.shift
        scen_out_tags = Tags.new file_lines.shift
        scen_out = ScenarioOutline.new file_lines.shift
        scen_out.tags = scen_out_tags
        scen_out_step_1 = Step.new file_lines.shift
        scen_out_step_2 = Step.new file_lines.shift
        scen_out.steps << [scen_out_step_1, scen_out_step_2]
        examples = Examples.new file_lines.shift
        row_1 = TableRow.new file_lines.shift
        row_2 = TableRow.new file_lines.shift
        row_3 = TableRow.new file_lines.shift
        examples.items << row_1
        examples.items << row_2
        examples.items << row_3
        scen_out.examples = examples
        feat.items << scen_out

        feat
      end

      context 'sample parser above' do
        it 'should parse out the feature like this' do
          res = simple_sample_feature_obj SIMPLE_FEATURE
          # puts res
          # ap res.to_s
          out = res.ai(plain: true, raw: true)
          str = <<-EOS.strip
#<Feature:placeholder_id
    attr_accessor :comments = #<Comment:placeholder_id
        attr_accessor :content = "# comment above feat"
    >,
    attr_accessor :content = "Feature: feat desc",
    attr_accessor :items = [
        [0] #<Comment:placeholder_id
            attr_accessor :content = "# comment above feat"
        >,
        [1] #<Tags:placeholder_id
            attr_accessor :content = "@feat_tag",
            attr_accessor :items = []
        >,
        [2] #<Scenario:placeholder_id
            attr_accessor :content = "  Scenario: scen desc",
            attr_accessor :items = [],
            attr_accessor :steps = [
                [0] [
                    [0] #<Step:placeholder_id
                        attr_accessor :content = "    Given this"
                    >,
                    [1] #<Step:placeholder_id
                        attr_accessor :content = "    When that"
                    >,
                    [2] #<Step:placeholder_id
                        attr_accessor :content = "    Then kod"
                    >
                ]
            ],
            attr_accessor :tags = #<Tags:placeholder_id
                attr_accessor :content = "  @scen_tag1 @scen_tag2",
                attr_accessor :items = []
            >,
            attr_accessor :title = " scen desc",
            attr_reader :keyword = "Scenario:"
        >,
        [3] #<ScenarioOutline:placeholder_id
            attr_accessor :content = "  Scenario Outline: scen outline desc <title>",
            attr_accessor :examples = #<Examples:placeholder_id
                attr_accessor :content = "    Examples:",
                attr_accessor :items = [
                    [0] #<TableRow:placeholder_id
                        attr_accessor :content = "      | title  | thing | thang |"
                    >,
                    [1] #<TableRow:placeholder_id
                        attr_accessor :content = "      | case 1 | 1     | one   |"
                    >,
                    [2] #<TableRow:placeholder_id
                        attr_accessor :content = "      | case 2 | 2     | two   |"
                    >
                ],
                attr_accessor :table_rows = nil,
                attr_accessor :title_row = nil
            >,
            attr_accessor :items = [],
            attr_accessor :steps = [
                [0] [
                    [0] #<Step:placeholder_id
                        attr_accessor :content = "    When this <thing>"
                    >,
                    [1] #<Step:placeholder_id
                        attr_accessor :content = "    Then that <thang>"
                    >
                ]
            ],
            attr_accessor :tags = #<Tags:placeholder_id
                attr_accessor :content = "  @scen_out_tag",
                attr_accessor :items = []
            >,
            attr_accessor :title = " scen outline desc <title>",
            attr_reader :keyword = "Scenario Outline:"
        >
    ],
    attr_accessor :tags = #<Tags:placeholder_id
        attr_accessor :content = "@feat_tag",
        attr_accessor :items = []
    >,
    attr_accessor :title = " feat desc",
    attr_reader :keyword = "Feature:"
>

          EOS
          # puts out
          expect(out).to be_similar_to(str)
          # expect(out).to eq(str)
          # expect(out).to match(str)
        end
      end
    end
  end
end