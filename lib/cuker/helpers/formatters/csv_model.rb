require_relative '../writers/abstract_writer'

module Cuker
  class CsvModel < AbstractModel
    include LoggerSetup

    attr_accessor :special_tag_list

    def initialize ast_map
      super
      @log.trace "initing #{self.class}"
      @log.debug "has #{ast_map.size} items"

      @asts = ast_map

      @order = make_order
      @title = make_title @order
      @data = make_rows
    end

    private

    def make_order
      [
          {:counter => "Sl.No"},
          {:s_type => "Type"},
          {:s_title => "Title"},
          # {:tags => special_tag_titles},
          {:feature_title => "Feature"},
          {:file_s_num => "S.no"},
          {:file_name => "File"},
          {:other_tags => "Tags"},
      ]
# todo: make title order reorderable
# todo: tag based reordering
    end

    def special_tag_titles
      @special_tag_titles ||= get_values_ary @special_tag_list if @special_tag_list
    end

    def special_tag_lookup
      @special_tag_lookup ||= get_keys_ary @special_tag_list if @special_tag_list
    end

    def make_title order
      get_values_ary order
    end

    def make_rows
      if @asts.nil? or @asts.empty?
        @log.warn "No asts to parse!"
        return []
      end

      total_counter = 0
      res = []
      @asts.each do |file_path, ast|
        @file_path = file_path
        in_feat_counter = 0
        if ast[:type] == :GherkinDocument
          in_feature(ast) do |feat_tags, feat_title, feat_item|
            in_item(feat_item) do |tags, title, type|
              all_tags = (feat_tags.to_set | tags.to_set).to_a # union
              special_tags, other_tags = filter_special_tags all_tags
              row_hsh = {
                  :counter => total_counter += 1,
                  :s_type => type,
                  :s_title => title,
                  :feature_title => feat_title,
                  :file_s_num => in_feat_counter += 1,
                  :file_name => @file_path,
                  :other_tags => other_tags.join(', '),

                  :tags => special_tags
              }
              row_ary = []
              get_keys_ary(@order).each {|k| row_ary << row_hsh[k]}
              # todo: a lot of flattening?
              res << row_ary
            end
          end
        end
      end
      @file_path = nil
      res
    end

    def filter_special_tags(all_tags)
      return [[],all_tags] unless special_tag_lookup
      ignore_list = all_tags - special_tag_lookup
      select_list = all_tags - ignore_list
      [select_list, ignore_list]
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
        @log.debug "Skipping BG"
      elsif item[:type] == :Scenario
        yield tags, item_title, "S"
      elsif item[:type] == :ScenarioOutline
        yield tags, item_title, "SO"
      else
        @log.warn "Unknown type '#{item[:type]}' found in file @ #{@file_path}"
      end
    end

  end

  class Identifier
    attr_accessor :name, :title, :pattern
  end

end

