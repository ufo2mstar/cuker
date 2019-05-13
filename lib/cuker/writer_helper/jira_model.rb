require_relative 'abstract_writer'
module Cuker
  class JiraModel < AbstractModel
    include LoggerSetup

    def initialize ast_map
      super
      @log.trace "initing #{self.class}"
      @log.debug "has #{ast_map.size} items"

      @asts = ast_map

      @order = make_order
      title = make_title @order
      data = make_rows

      @title = [surround(title, '||')]
      @data = data.join("\n").split("\n")
    end

    private

    def make_order
      [
          # {:counter => "Sl.No"},
          {:s_num => "Scen ID"},
          {:s_content => "Scenario"},
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
          in_feature(ast) do |feat_tags, feat_title, feat_item|
            in_item(feat_item) do |tags, title, content|
              row_hsh = {
                  :s_num => "#{feat_counter}.#{in_feat_counter += 1}",
                  :s_content => content.join("\n"),
                  :item => "(/)",
              }
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
        children.each do |item|
          yield feat_tags, feat_title, item
        end
      else
        @log.warn "No Features found in file @ #{@file_path}"
      end
    end

    def in_item(item)
      item_title = name_merge item
      tags = get_tags item
      if item[:type] == :Background
        # get_steps(hsh)
        # todo: think about handling this
      elsif item[:type] == :Scenario
        yield tags, item_title, get_steps(item)
      elsif item[:type] == :ScenarioOutline
        yield tags, item_title, get_steps(item)
      else
        @log.warn "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
      end
    end

    def get_steps(hsh)
      if hsh[:steps] and hsh[:steps].any?
        content = []
        steps = hsh[:steps]
        in_step(steps) do |step|
          content += step
        end
        content
      else
        @log.warn "No Tags found in #{hsh[:keyword]} @ #{@file_path}"
        []
      end
    end

    def in_step(steps)
      # todo: table
      steps.each do |step|
        if step[:type] == :Step
          step_ary = []
          step_ary << [
              step[:keyword].strip,
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
      else
        @log.warn "Unknown type '#{arg[:type]}' found in file @ #{@file_path}"
      end
      []
    end

    def get_tags(hsh)
      if hsh[:tags] and hsh[:tags].any?
        hsh[:tags].map {|tag| tag[:name]}
      else
        @log.warn "No Tags found in #{hsh[:keyword]} @ #{@file_path}"
        []
      end
    end

    def union feat_tags, tags
      (feat_tags.to_set | tags.to_set).to_a # union
    end

    def surround ary, sep
      "#{sep}#{ary.join(sep)}#{sep}"
    end

    def name_merge hsh
      str = ""
      @log.warn hsh
      str += hsh[:name].strip.force_encoding("UTF-8") if hsh[:name]
      str += hsh[:description].strip.force_encoding("UTF-8") if hsh[:description]
      str
    end
  end
end