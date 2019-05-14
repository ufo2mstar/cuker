require_relative 'abstract_writer'
module Cuker
  class JiraModel < AbstractModel
    include LoggerSetup

    JIRA_ICONS = {
        info: "(i)",
        pass: "(/)",
        fail: "(x)",
        exclam: "(!)",
        question: "(?)",
    }

    def initialize ast_map
      super
      @log.trace "initing #{self.class}"
      @log.debug "has #{ast_map.size} items"

      @asts = ast_map

      @order = make_order
      title = make_title @order
      data = make_rows

      @title = surround(title, '||')
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
# # todo: make title order reorderable
# # todo: tag based reordering
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
        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags_ary, feat_title, feat_item|
            in_item(feat_item) do |tags_ary, title, type, content_ary|
              row_hsh = {}
              if type == :Background
                row_hsh = {
                    :s_num => "#{feat_counter}",
                    :s_title => "Feature: #{feat_title}\nBackground: #{title}",
                    :s_content => surround_panel(content_ary.join("\n")),
                    :item => simple_surround(JIRA_ICONS[:empty], '|'),
                }
              elsif type == :Scenario or type == :ScenarioOutline
                row_hsh = {
                    :s_num => "#{feat_counter}.#{in_feat_counter += 1}",
                    :s_title => title,
                    :s_content => surround_panel(content_ary.join("\n")),
                    :item => simple_surround(JIRA_ICONS[type == :ScenarioOutline ? :info : :exclam], '|'),
                }
              elsif type == :Examples
                row_hsh = {
                    :s_num => "#{feat_counter}.#{in_feat_counter}.x",
                    :s_title => title, # example title
                    :s_content => surround_panel(content_ary.join("\n")),
                    :item => simple_surround(JIRA_ICONS[:info], '|'),
                }
              end
              row_ary = []
              get_keys_ary(@order).each {|k| row_ary << row_hsh[k]}
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
          res << " "

          eg_title = "Examples: #{name_merge(example)}"
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
        cell_hsh[:value]
      else
        @log.warn "Expected :TableCell in #{cell_hsh} @ #{@file_path}"
      end
    end

    def in_step(steps)
      steps.each do |step|
        if step[:type] == :Step
          step_ary = []
          step_ary << [
              "*#{step[:keyword].strip}*", # bolding the keywords
              step[:text].strip
          ].join(" ")
          step_ary += in_step_args(step[:argument]) if step[:argument]
          # todo: padding as needed
          yield step_ary
        else
          @log.warn "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
        end
      end
    end

    def in_step_args arg
      if arg[:type] == :DataTable
        res = []
        arg[:rows].each_with_index do |row, i|
          sep = i == 0 ? '||' : '|'
          res << surround(row[:cells].map {|hsh| hsh[:value]}, sep)
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

    def surround_panel str, title = nil
      if title
        "{panel:title = #{title}} #{str} {panel}"
      else
        "{panel} #{str} {panel}"
      end
    end

  end
end