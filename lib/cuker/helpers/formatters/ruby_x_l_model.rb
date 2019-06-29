require_relative '../writers/abstract_writer'
require 'text-table'

module Cuker
  module ExcelSupport
    EXCEL_BLANK = ''
    EXCEL_TABLE_PADDING = 7

    def surround_panel str, title = nil
      if title
        "{panel:title = #{title}} #{str} {panel}"
      else
        "{panel} #{str} {panel}"
      end
    end

    def surround_color str, color = nil
      if title
        "{color:#{color}} #{str} {color}"
      else
        "{color} #{str} {color}"
      end
    end

    def excel_content_format ary
      ary.join "\n"
    end

    def excel_title keyword, title_ary
      # "#{excel_bold "#{keyword}:"}\n #{title}\n "
      [excel_bold("#{keyword}:")] + title_ary
    end

    def excel_arg_hilight(str)
      # str.gsub(/<(.*)?>/, excel_bold_italics('<\1>'))
      str.gsub(/<.*?>/, &method(:excel_bold_italics))
    end

    def excel_bold_italics(str)
      # make excel_bold_italics?
      excel_bold(excel_italics(str))
    end

    def excel_bold str
      # make bold?
      str
    end

    def excel_monospace str
      # make monospaced?
      str
    end

    def excel_italics(str)
      # make excel_italics?
      str
    end

    def excel_blank_pad str
      s = str.strip
      s.empty? ? EXCEL_BLANK : s
    end

    # Properly spaced out tables
    # def tableify header_ary, rows_ary
    # @return [Array] tableified string array
    # https://www.rubydoc.info/gems/text-table/1.2.4
    def tableify header_and_rows_ary, padding = 0
      table = Text::Table.new(:horizontal_padding => 1,
                              :vertical_boundary => '-',
                              :horizontal_boundary => '|',
                              :boundary_intersection => '+',
                              # :boundary_intersection => '-',
                              # :boundary_intersection => ' ',
                              :first_row_is_head => true,
      # :rows => header_and_rows_ary # works only for to_table
      )
      table.head = header_and_rows_ary[0]
      table.rows = header_and_rows_ary[1..-1]

      # table.to_s
      # table.rows = header_and_rows_ary
      #
      # table = header_and_rows_ary.to_table(:first_row_is_head => true)

      res = table.to_s.split("\n")
      res.map {|row_str| ' ' * padding + row_str}
    end

  end
  class RubyXLModel < AbstractModel
    include LoggerSetup
    include StringHelper
    include ExcelSupport

    attr_accessor :special_tag_list

    TITLE_MAX_LEN = 60

    EXCEL_BLANK = ''
    EXCEL_TITLE_SEP = '|'
    EXCEL_ROW_SEP = '|'
    EXCEL_EMPTY_LINE = ' '
    EXCEL_NEW_LINE = "\n"
    EXCEL_HORIZ_RULER = '   '

    EXCEL_OFFSET = 6

    def initialize ast_map
      super
      @log.trace "initing #{self.class}"
      @log.debug "has #{ast_map.size} items"

      @asts = ast_map

      @order = make_order
      @title = make_title @order
      @data = make_rows
    end

    # private

    def make_order
      [
# todo: template{:col_key => ["Title text",fill_color,font, etc]},
          {:counter => "Sl.No"},
          {:feature => "Feature"},
          {:background => "Background"},
          {:scenario => "Scenario"},
          {:examples => "Examples"},
          {:result => "Result"},
          {:tested_by => "Tested By"},
          {:test_designer => "Test Designer"},
          {:comments => "Comments"},
      ]
# todo: make title order reorderable
# todo: tag based reordering
    end

    def make_title order
      get_values_ary order
    end

    def special_tag_titles
      @special_tag_titles ||= get_values_ary @special_tag_list if @special_tag_list
    end

    def special_tags
      @special_tags ||= get_keys_ary @special_tag_list if @special_tag_list
    end

    def filter_special_tags(all_tags)
      return [[], all_tags] unless special_tags
      ignore_list = all_tags - special_tags
      select_list = all_tags - ignore_list
      [select_list, ignore_list]
    end

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.debug "No asts to parse!"
        return []
      end

      feat_counter = 1
      feat_content = []
      bg_content = []

      res = []
      @asts.each do |file_path, ast|
        @log.debug "Understanding file: #{file_path}"
        @file_path = file_path
        in_feat_counter = 0

        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
            in_item(feat_item) do |tags_ary, type, item_title, content_ary, example_ary|
              row_hsh = {}
              feat_content = excel_title FEATURE, feat_title
              if type == :Background or type == :Feature
                bg_content = [excel_title(BACKGROUND, item_title)] + content_ary
              else
                # if type == :Scenario or type == :ScenarioOutline
                scen_content = [excel_title(type.to_s, item_title)] + content_ary

                row_hsh[:counter] = "#{feat_counter}.#{in_feat_counter += 1}"
                row_hsh[:feature] = excel_content_format feat_content
                row_hsh[:background] = excel_content_format bg_content
                row_hsh[:scenario] = excel_content_format scen_content
                row_hsh[:result] = EXCEL_CONSTS::RESULT::PENDING
                row_hsh[:tested_by] = ""
                row_hsh[:test_designer] = ""
                row_hsh[:comments] = ""

                # row_hsh[:examples] = "" # is nil by default
                if type == :ScenarioOutline
                  row_hsh[:examples] = excel_content_format example_ary
                end
                row_ary = []
                get_keys_ary(@order).each {|k| row_ary << (row_hsh[k])}
                # get_keys_ary(@order).each {|k| row_ary << excel_arg_hilight(row_hsh[k])}
                res << row_ary
              end
            end
          end
        end
        feat_counter += 1
        feat_title = []
        bg_content = []
      end
      @file_path = nil
      res
    end

    def in_feature(hsh)
      if hsh[:feature]
        feat = hsh[:feature]

        feat_tags = get_tags feat
        feat_title = get_title_ary feat

        children = feat[:children]
        children.each {|child| yield feat_tags, feat_title, child}
      else
        @log.debug "No Features found in file @ #{@file_path}"
      end
    end

    def in_item(child)
      item_title = get_title_ary child
      tags = get_tags child
      if child[:type] == :Background
        yield tags, child[:type], item_title, get_steps(child), []
        # elsif !@feat_printed
        #   yield [], EXCEL_BLANK, :Feature, [EXCEL_BLANK]
        #   yield tags, child[:type], item_title, get_steps(child), []
      elsif child[:type] == :Scenario
        yield tags, child[:type], item_title, get_steps(child), []
      elsif child[:type] == :ScenarioOutline
        yield tags, child[:type], item_title, get_steps(child), get_examples(child[:examples])
        #   todo: think about new examples in new lines
      else
        @log.debug "Unknown type '#{child[:type]}' found in file @ #{@file_path}"
      end
    end

    def in_step(steps)
      steps.each do |step|
        if step[:type] == :Step
          step_ary = []
          step_str = [
              ((excel_bold(step[:keyword].strip)).rjust(EXCEL_OFFSET)), # bolding the keywords
              (step[:text].strip)
          ].join(' ')

          # step_ary << excel_monospace(step_str)
          step_ary << (step_str)

          step_ary += tableify(get_step_args(step[:argument]), EXCEL_TABLE_PADDING) if step[:argument]
          # todo: DOC string handle?
          yield step_ary
        else
          @log.debug "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
        end
      end
    end

    # helps handle tables for now
    def get_step_args arg
      if arg[:type] == :DataTable
        res = []
        arg[:rows].each_with_index do |row, i|
          # sep = i == 0 ? EXCEL_TITLE_SEP : EXCEL_ROW_SEP
          # res << surround(row[:cells].map {|hsh| excel_blank_pad hsh[:value]}, sep)
          res << row[:cells].map {|hsh| hsh[:value]}
        end
        return res
      elsif arg[:type] == :DocString
        # todo: handle if needed
        @log.debug "Docstrings found in '#{arg}' found in file @ #{@file_path}"
      else
        @log.debug "Unknown type '#{arg[:type]}' found in file @ #{@file_path}"
      end
      []
    end

    def get_steps(hsh)
      if hsh[:steps] and hsh[:steps].any?
        content = []
        steps = hsh[:steps]
        in_step(steps) {|step| content += step}
        content
      else
        @log.debug "No Tags found in #{hsh[:keyword]} @ #{@file_path}"
        []
      end
    end

    def get_examples(examples)
      res = []
      examples.each do |example|
        if example[:type] == :Examples
          # example_data << EXCEL_HORIZ_RULER
          example_data = []

          eg_title = excel_title EXAMPLES, get_title_ary(example)
          res << eg_title

          table_header = example[:tableHeader]
          eg_header = table_header.nil? ? [] : get_table_row(table_header)
          example_data << eg_header

          eg_body = example[:tableBody]
          eg_body.map {|row_hsh| example_data << get_table_row(row_hsh)} unless eg_body.nil?

          res << tableify(example_data)
          res << EXCEL_HORIZ_RULER
        else
          @log.debug "Unknown type '#{example[:type]}' found in file @ #{@file_path}"
        end
      end
      res
    end

    def get_table_row row_hsh
      if row_hsh[:type] == :TableRow
        row_hsh[:cells].map(&method(:get_table_cell))
      else
        @log.debug "Expected :TableRow in '#{row_hsh}' @ #{@file_path}"
        []
      end
    end

    def get_table_cell cell_hsh
      if cell_hsh[:type] == :TableCell
        val = cell_hsh[:value].strip
        val.empty? ? EXCEL_BLANK : val
      else
        @log.debug "Expected :TableCell in '#{cell_hsh}' @ #{@file_path}"
        EXCEL_BLANK
      end
    end

    def get_title_ary hsh, max_len = TITLE_MAX_LEN
      title_ary = []
      title_ary << hsh[:name].strip.force_encoding("UTF-8") if hsh[:name]
      title_ary << hsh[:description].strip.force_encoding("UTF-8") if hsh[:description]
      title_ary
    end


    class Identifier
      attr_accessor :name, :title, :pattern
    end

    module EXCEL_CONSTS
      module RESULT
        PENDING = "Pending"
        PASS = "Pass"
        FAIL = "Fail"
        QUESTION = "Question"
        NULL = ""
      end
    end

  end
end

