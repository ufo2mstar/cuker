require_relative '../writers/abstract_writer'

module Cuker
  module ExcelSupport

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

    def excel_title keyword, title
      "#{excel_bold "#{keyword}:"}\n #{title}\n "
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
    EXCEL_HORIZ_RULER = ''

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
          # {:counter => "Sl.No"},
          # {:feature_title => "Feature"},
          # {:s_type => "Type"},
          # {:s_title => "Title"},
          # {:tags => special_tag_titles},
          # {:file_s_num => "S.no"},
          # {:file_name => "File"},
          # {:other_tags => "Tags"},
          {:counter => "Sl.No"},
          {:feature => "Feature"},
          {:background => "Background"},
          {:scenario => "Scenario"},
          {:examples => "Examples"},
          {:result => "Result"},
          {:tested_by => "Tested By"},
          {:test_designer => "Test Designer"},
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

    def special_tag_lookup
      @special_tag_lookup ||= get_keys_ary @special_tag_list if @special_tag_list
    end

    def filter_special_tags(all_tags)
      return [[], all_tags] unless special_tag_lookup
      ignore_list = all_tags - special_tag_lookup
      select_list = all_tags - ignore_list
      [select_list, ignore_list]
    end

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.warn "No asts to parse!"
        return []
      end

      feat_counter = 1

      feat_content = ''
      bg_content = ''

      res = []
      @asts.each do |file_path, ast|

        @file_path = file_path
        in_feat_counter = 0
        # @feat_printed = false

        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
            in_item(feat_item) do |tags_ary, title, type, content_ary, example_ary|

              row_hsh = {}

              if type == :Background or type == :Feature

                # @feat_printed = true

                title_str = ''
                # feat handle
                title_str += excel_title 'Feature', feat_title
                # title_str += excel_title('Background', title) if type == :Background
                row_hsh = {
                    # :s_num => "#{feat_counter}",
                    # :s_title => surround_panel(title_str),
                    # :s_content => surround_panel(content_ary.join("\n")),
                    # :item => simple_surround(EXCEL_ICONS[:empty], '|'),
                }
                feat_content = "Feature:\n#{title_str}"
                bg_content = content_ary.join("\n")
              elsif type == :Scenario or type == :ScenarioOutline
                # row_hsh = {
                # :s_num => "#{feat_counter}.#{in_feat_counter += 1}",
                # :s_title => surround_panel(excel_title(type, title)),
                # :s_content => surround_panel(content_ary.join("\n")),
                # # :item => simple_surround(EXCEL_ICONS[type == :ScenarioOutline ? :info : :exclam], '|'),
                # :item => simple_surround(EXCEL_ICONS[:info], '|'),

                row_hsh[:counter] = "#{feat_counter}.#{in_feat_counter += 1}"
                row_hsh[:feature] = "#{title}"
                row_hsh[:background] = bg_content
                row_hsh[:scenario] = content_ary.join("\n")

                row_hsh[:result] = ""
                row_hsh[:tested_by] = ""
                row_hsh[:test_designer] = ""


              elsif type == :Examples
                row_hsh[:examples] = ""
              end
              row_ary = []
              # get_keys_ary(@order).each {|k| row_ary << excel_arg_hilight(row_hsh[k])}
              res << row_ary
            end
          end
        end
        feat_counter += 1
        feat_content = ''
        bg_content = ''
      end
      @file_path = nil
      res
    end

    def in_feature(hsh)
      if hsh[:feature]
        feat = hsh[:feature]

        feat_tags = get_tags feat
        feat_title = name_merge feat

        children = feat[:children]
        children.each {|child| yield feat_tags, feat_title, child}
      else
        @log.warn "No Features found in file @ #{@file_path}"
      end
    end

    def in_item(child)
      item_title = name_merge child
      tags = get_tags child
      if child[:type] == :Background
        yield tags, item_title, child[:type], get_steps(child), []
        # elsif !@feat_printed
        #   yield [], EXCEL_BLANK, :Feature, [EXCEL_BLANK]
        #   yield tags, item_title, child[:type], get_steps(child), []
      elsif child[:type] == :Scenario
        yield tags, item_title, child[:type], get_steps(child), []
      elsif child[:type] == :ScenarioOutline
        yield tags, item_title, child[:type], get_steps(child), get_examples(child[:examples])
        #   todo: think about new examples in new lines
      else
        @log.warn "Unknown type '#{child[:type]}' found in file @ #{@file_path}"
      end
    end

    def in_step(steps)
      steps.each do |step|
        if step[:type] == :Step
          step_ary = []
          step_str = [
              ((excel_bold(step[:keyword].strip)).rjust(7)), # bolding the keywords
              (step[:text].strip)
          ].join(' ')

          # step_ary << excel_monospace(step_str)
          step_ary << (step_str)

          step_ary += in_step_args(step[:argument]) if step[:argument]
          # todo: DOC string handle?
          # todo: padding as needed
          yield step_ary
        else
          @log.warn "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
        end
      end
    end

    # helps handle tables for now
    def in_step_args arg
      if arg[:type] == :DataTable
        res = []
        arg[:rows].each_with_index do |row, i|
          # sep = i == 0 ? EXCEL_TITLE_SEP : EXCEL_ROW_SEP
          # res << surround(row[:cells].map {|hsh| excel_blank_pad hsh[:value]}, sep)
        end
        return res
      elsif arg[:type] == :DocString
        # todo: handle if needed
        @log.warn "Docstrings found in '#{arg}' found in file @ #{@file_path}"
      else
        @log.warn "Unknown type '#{arg[:type]}' found in file @ #{@file_path}"
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
        @log.warn "No Tags found in #{hsh[:keyword]} @ #{@file_path}"
        []
      end
    end

    def get_examples(examples)
      res = []
      examples.each do |example|
        if example[:type] == :Examples
          # res << EXCEL_HORIZ_RULER

          eg_title = excel_title 'Examples', name_merge(example)
          res << eg_title

          eg_header = surround(get_table_row(example[:tableHeader]), '||')
          res << eg_header

          eg_rows = example[:tableBody]
          eg_rows.map {|row_hsh| res << surround(get_table_row(row_hsh), '|')}

        else
          @log.warn "Unknown type '#{example[:type]}' found in file @ #{@file_path}"
        end
      end
      res
    end

    def get_table_row row_hsh
      if row_hsh[:type] == :TableRow
        row_hsh[:cells].map(&method(:get_table_cell))
      else
        @log.warn "Expected :TableRow in #{row_hsh} @ #{@file_path}"
        []
      end
    end

    def get_table_cell cell_hsh
      if cell_hsh[:type] == :TableCell
        val = cell_hsh[:value].strip
        val.empty? ? EXCEL_BLANK : val
      else
        @log.warn "Expected :TableCell in #{cell_hsh} @ #{@file_path}"
        EXCEL_BLANK
      end
    end

    def name_merge hsh, max_len = TITLE_MAX_LEN
      str = ''
      @log.debug "name merge for #{hsh} with max_len (#{max_len})"
      str += add_newlines!(hsh[:name].strip.force_encoding("UTF-8"), max_len) if hsh[:name]
      str += add_newlines!("\n#{hsh[:description].strip.force_encoding("UTF-8")}", max_len) if hsh[:description]
      str
    end


    class Identifier
      attr_accessor :name, :title, :pattern
    end

    module EXCEL
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

