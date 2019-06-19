require_relative '../writers/abstract_writer'
module Cuker
  class JiraModel < AbstractModel
    include LoggerSetup

    include StringHelper
    TITLE_MAX_LEN = 40

    JIRA_BLANK = ' '
    JIRA_TITLE_SEP = '||'
    JIRA_ROW_SEP = '|'
    JIRA_EMPTY_LINE = '(empty line)'
    JIRA_NEW_LINE = '\\\\'
    JIRA_HORIZ_RULER = '----'

    JIRA_ICONS = {
        info: "(i)",
        pass: "(/)",
        fail: "(x)",
        exclam: "(!)",
        question: "(?)",
        empty: JIRA_BLANK
    }


    def initialize ast_map
      super
      @log.trace "initing #{self.class}"
      @log.debug "has #{ast_map.size} items"

      @asts = ast_map

      @order = make_order
      title = make_title @order
      data = make_rows

      @title = surround(title, JIRA_TITLE_SEP)
      @data = data.join("\n").split("\n")
    end

    private

    def make_order
      [
          # {:counter => "Sl.No"},
          {:s_num => "Scen ID"},
          {:s_title => "Feature/Scenario"},
          {:s_content => "Steps"},
          {:item => "Result"},
      ]
    end

    def make_title order
      get_values_ary order
    end

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.warn "No asts to parse!"
        return []
      end

      feat_counter = 1
      res = []
      @asts.each do |file_path, ast|
        @file_path = file_path
        in_feat_counter = 0
        @feat_printed = false
        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
            in_item(feat_item) do |tags_ary, title, type, content_ary|
              row_hsh = {}
              if type == :Background or type == :Feature
                @feat_printed = true
                title_str = ''
                # feat handle
                title_str += jira_title 'Feature', feat_title
                title_str += jira_title('Background', title) if type == :Background
                row_hsh = {
                    :s_num => "#{feat_counter}",
                    :s_title => surround_panel(title_str),
                    :s_content => surround_panel(content_ary.join("\n")),
                    :item => simple_surround(JIRA_ICONS[:empty], '|'),
                }
              elsif type == :Scenario or type == :ScenarioOutline
                row_hsh = {
                    :s_num => "#{feat_counter}.#{in_feat_counter += 1}",
                    :s_title => surround_panel(jira_title(type, title)),
                    :s_content => surround_panel(content_ary.join("\n")),
                    # :item => simple_surround(JIRA_ICONS[type == :ScenarioOutline ? :info : :exclam], '|'),
                    :item => simple_surround(JIRA_ICONS[:info], '|'),
                }
              elsif type == :Examples
                row_hsh = {
                    :s_num => "#{feat_counter}.#{in_feat_counter}.x",
                    :s_title => surround_panel(jira_title(type, title)), # example title
                    :s_content => surround_panel(content_ary.join("\n")),
                    :item => simple_surround(JIRA_ICONS[:info], '|'),
                }
              end
              row_ary = []
              get_keys_ary(@order).each {|k| row_ary << jira_arg_hilight(row_hsh[k])}
              res << surround(row_ary, '|')
            end
          end
        end
        feat_counter += 1
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
        children.each do |child|
          yield feat_tags, feat_title, child
        end
      else
        @log.warn "No Features found in file @ #{@file_path}"
      end
    end

    def in_item(child)
      item_title = name_merge child
      tags = get_tags child
      if child[:type] == :Background
        yield tags, item_title, child[:type], get_steps(child)
      elsif !@feat_printed
        yield [], JIRA_BLANK, :Feature, [JIRA_BLANK]
        yield tags, item_title, child[:type], get_steps(child)
      elsif child[:type] == :Scenario
        yield tags, item_title, child[:type], get_steps(child)
      elsif child[:type] == :ScenarioOutline
        yield tags, item_title, child[:type], get_steps(child)
        #   todo: think about new examples in new lines
      else
        @log.warn "Unknown type '#{child[:type]}' found in file @ #{@file_path}"
      end
    end

    def get_steps(hsh)
      if hsh[:steps] and hsh[:steps].any?
        content = []
        steps = hsh[:steps]
        in_step(steps) do |step|
          content += step
        end
        content += in_example(hsh[:examples]) if hsh[:examples]
        content
      else
        @log.warn "No Tags found in #{hsh[:keyword]} @ #{@file_path}"
        []
      end
    end

    def in_example(examples)
      res = []
      examples.each do |example|
        if example[:type] == :Examples
          res << JIRA_HORIZ_RULER

          eg_title = jira_title 'Examples', name_merge(example)
          res << eg_title

          eg_header = surround(in_table_row(example[:tableHeader]), '||')
          res << eg_header

          eg_rows = example[:tableBody]
          eg_rows.map {|row_hsh| res << surround(in_table_row(row_hsh), '|')}

        else
          @log.warn "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
        end
      end
      res
    end

    def in_table_row row_hsh
      if row_hsh[:type] == :TableRow
        row_hsh[:cells].map(&method(:in_table_cell))
      else
        @log.warn "Expected :TableRow in #{row_hsh} @ #{@file_path}"
        []
      end
    end

    def in_table_cell cell_hsh
      if cell_hsh[:type] == :TableCell
        val = cell_hsh[:value].strip
        val.empty? ? JIRA_BLANK : val
      else
        @log.warn "Expected :TableCell in #{cell_hsh} @ #{@file_path}"
        JIRA_BLANK
      end
    end

    def in_step(steps)
      steps.each do |step|
        if step[:type] == :Step
          step_ary = []
          step_str = [
              ((jira_bold(step[:keyword].strip)).rjust(7)), # bolding the keywords
              (step[:text].strip)
          ].join(' ')

          # step_ary << jira_monospace(step_str)
          step_ary << (step_str)

          step_ary += in_step_args(step[:argument]) if step[:argument]
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
          sep = i == 0 ? JIRA_TITLE_SEP : JIRA_ROW_SEP
          res << surround(row[:cells].map {|hsh| jira_blank_pad hsh[:value]}, sep)
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

    def name_merge hsh, max_len = TITLE_MAX_LEN
      str = ""
      @log.debug "name merge for #{hsh} with max_len (#{max_len})"
      str += add_newlines!(hsh[:name].strip.force_encoding("UTF-8"), max_len) if hsh[:name]
      str += add_newlines!("\n#{hsh[:description].strip.force_encoding("UTF-8")}", max_len) if hsh[:description]
      str
    end

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

    def jira_title keyword, title
      "#{jira_bold "#{keyword}:"}\n #{title}\n "
    end

    def jira_arg_hilight(str)
      # str.gsub(/<(.*)?>/, jira_bold_italics('<\1>'))
      str.gsub(/<.*?>/, &method(:jira_bold_italics))
    end

    def jira_bold str
      simple_surround str, '*'
    end

    def jira_monospace str
      simple_surround str, '{{', '}}'
    end

    def jira_bold_italics(str)
      jira_bold(jira_italics(str))
    end

    def jira_italics(str)
      simple_surround(str, '_')
    end

    def jira_blank_pad str
      s = str.strip
      s.empty? ? JIRA_BLANK : s
    end
  end
end